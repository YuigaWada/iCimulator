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

import numpy as np
import cv2
import socket
import io
import math
import sys
import os

from PIL import Image

dirname = os.path.dirname(os.path.abspath(__file__)) + '/resources/'

verbose = False
camera_mode = False

def launch_logo():
    with open(dirname + 'sprash.txt','r') as file:
        print(file.read())

def verbose_print(text):
    if verbose:
        print(text)

def organize_color(image_array): # While OpenCV uses BGR, Pillow uses RGB so we have to convert the color pattern.
    return cv2.cvtColor(image_array, cv2.COLOR_BGR2RGB)

def image_to_bytes(image: Image):
  imgByteArr = io.BytesIO()
  image.save(imgByteArr, format='PNG')
  imgByteArr = imgByteArr.getvalue()
  return imgByteArr

def load_argument():

    def verbose_on():
        global verbose

        verbose = True
        print(' ~ verbose mode ~ ')

    def camera_on():
        global camera_on

        camera_mode = True
        print(' ~ camera mode ~ ')

    def print_help():
        with open(dirname + 'command_help.txt','r') as file:
            print(file.read())
        exit()

    arguments = sys.argv
    patterns = {'verbose' : verbose_on , 'camera' : camera_on , 'help' : print_help }

    for argument in arguments:
        for target_argument, function in patterns.items():
            for format in ['-' , '--']:

                target = format + target_argument
                if argument == format + target_argument or argument == format + target_argument[0]:
                    function()


def capture():
    UDP_IP = '127.0.0.1'
    UDP_PORT = 5005
    MAX_PACKET = 9216

    cap = cv2.VideoCapture(0)
    ret, frame = cap.read()

    if camera_mode:
        cv2.imshow('frame',frame)

    while(True):
        ret, frame = cap.read()

        if camera_mode:
            cv2.imshow('frame',frame)

        sock = socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
        image = Image.fromarray(organize_color(frame))
        raw_data = image_to_bytes(image)
        verbose_print('\nCaptured: ImageSize → ' + str(len(raw_data)))


        sock.sendto(b'.', (UDP_IP, UDP_PORT)) #画像データの始まりを示す識別子
        for i in range(math.ceil(len(raw_data) / MAX_PACKET)):
            sock.sendto(raw_data[i*MAX_PACKET:(i+1)*MAX_PACKET],(UDP_IP, UDP_PORT)) # https://stackoverflow.com/questions/22819214/udp-message-too-long

        verbose_print('Success! Packets are sent.')

        if not verbose:
            print('Success.')

        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    cap.release()
    cv2.destroyAllWindows()






def main():
    launch_logo()
    load_argument()

    print('\nIf you need some help, use command \'-h\'. \n\nRunning...')
    capture()



if __name__ == '__main__':
    main()
