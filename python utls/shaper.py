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


#This python code shapes the source code templates(?) (example: AVCaptureStillImageOutput) which we can watch on XCode in order to simulate (or disguise?) AVCapture~~ classes.
import re
import os
import sys
import shutil

patterns = [['/\\*[\\s\\S]*?\\*/|//.*',''] , ['//.+\n',''] , ['@available.+\n',''] , ['\s+\n', '\n']]

def load_argument():
    arguments = sys.argv
    if len(arguments) != 2:
        print('Invalid Arguments.')
        exit()
    else:
        return arguments[1]


def check_format(target_path):
    if target_path[-6:] != '.swift':
        print("Invalid File Format. (It's not a swift code.)")
        exit()


def shape(target_path):
    file = open(target_path)
    raw_text = file.read()

    for pattern, result in patterns:
        raw_text = re.sub(pattern, result, raw_text,flags=re.MULTILINE)

    return raw_text


def write(target_path, shaped_text):
    create_backup(target_path, shaped_text)

    file = open(target_path, mode='w')
    file.write(shaped_text)


def create_backup(old_path, text):
    new_path = old_path[0:-6] + '_backup.swift'

    if os.path.exists(new_path) == True:
        print('Backup already exists.')


    shutil.copyfile(old_path, new_path)

def main():
    target_path = load_argument()
    check_format(target_path)

    shaped_text = shape(target_path)
    print(shaped_text)
    write(target_path, shaped_text)



main()
print("Success!")
