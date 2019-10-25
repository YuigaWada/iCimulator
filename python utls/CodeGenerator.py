# MIT License
#
# Copyright (c) 2019 YuigaWada
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


#This python code shapes the source code templates(?) (,which we can watch on XCode) in order to simulate (or disguise?) AVCapture~~ classes.

import re
import os
import sys
import shutil
import requests

class Shaper: # Just Shape.
    patterns = [['/\\*[\\s\\S]*?\\*/|//.*',''] , ['//.+\n',''] , ['@available.+\n',''] , ['\s+\n', '\n']]
    target_path = ""

    def __init__(self, path):
        self.target_path = path

    def check_format(self):
        if self.target_path[-6:] != '.swift':
            print("Invalid File Format. (It's not a swift code.)")
            exit()


    def shape(self):
        with open(self.target_path) as file:
            raw_text = file.read()

            for pattern, result in self.patterns:
                raw_text = re.sub(pattern, result, raw_text,flags=re.MULTILINE)

            return raw_text


    def write(self, shaped_text):
        self.create_backup(shaped_text)

        with open(self.target_path, mode='w') as file:
            file.write(shaped_text)


    def create_backup(self, text):
        new_path = self.target_path[0:-6] + '_backup.swift'

        if os.path.exists(new_path) == True:
            print('Backup already exists.')


        shutil.copyfile(self.target_path, new_path)

    def start(self): # Main
        self.check_format()

        shaped_text = self.shape()
        # self.write(shaped_text)
        return shaped_text


class CodeComplementor: # Complement an incomplete source code.
    patterns = {'Bool' : 'true' , 'NSNumber' : '1' , 'Int' : '1' , 'CGFloat' : '1' , 'String' : '""' , "OSType" : ".max" , 'Int64' : '1'}

    typealiases = {} # example: {'AVCaptureDevice': 'FakeCaptureDevice'}
    raw_text = ""

    def __init__(self, raw_text):
        self.raw_text = raw_text

        # Gets data of targets to be typealiased.
        typealiases_header = requests.get('https://raw.githubusercontent.com/YuigaWada/iCimulator/master/templates/iCimulator.swift').text.splitlines()
        for text in typealiases_header:
            search_result = re.compile('public typealias ([^=]+) = (.+)').search(text)
            if search_result != None:
                self.typealiases[search_result.group(1)] = search_result.group(2)

    def typealias(self):
        for target, replaced in self.typealiases.items():
            self.raw_text = self.raw_text.replace(target, replaced)




    def set_default_value(self): # :Class { get } → :Class = ~~
        def create_var_templates(target):
            template1 =  ': ' + target + ''
            template2 =  ': ' + target + '?'

            return [template1,template2]

        def create_list_templates(target):
            template3 =  ': [' + target + ']'
            template4 =  ': [' + target + '?]'
            template5 =  ': [' + target + ']?'

            return [template3,template4,template5]

        def reshape():
            self.raw_text = self.raw_text.replace(' { get }', '')


        reshape()
        new_text = ""
        for line in self.raw_text.splitlines():
            is_replaced = False
            for target, value in self.patterns.items():



                if target in line:
                    for template in create_var_templates(target):
                        if len(line) >= len(template):
                            if line[(-1)*len(template):] == template:
                                line += ' = ' + value

                                new_text += line + '\n' # update line.
                                is_replaced = True
                                break

                    for template in create_list_templates(target):
                        if len(line) >= len(template):
                            if line[(-1)*len(template):] == template:
                                line += ' = [' + value + ']'

                                new_text += line + '\n' # update line.
                                is_replaced = True
                                break

                    if is_replaced:
                        break


            if not is_replaced:
                new_text += line + '\n' # update line.

        self.raw_text = new_text


    def generate(self): # Main
        self.typealias()
        self.set_default_value()
        return self.raw_text




def load_argument():
    arguments = sys.argv
    if len(arguments) != 2:
        print('Invalid Arguments.')
        exit()
    else:
        return arguments[1]

def main():
    target_path = load_argument()

    shaper = Shaper(target_path)
    shaped_text = shaper.start()

    complementor = CodeComplementor(shaped_text)
    new_code = complementor.generate()

    shaper.write(new_code)

    print(new_code)
    print("Success!")



if __name__ == '__main__':
    main()
