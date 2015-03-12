#!/usr/bin/python

import easygui as eg
import subprocess
import time
import sys
import picamera
from os import *
from Tkinter import *

while True:
  if eg.ccbox("Press Continue to start photobooth", title="Photobooth v1.0a"):
    ##picamera class , start as soon as pressed continue
    camera = picamera.PiCamera()
    camera.hflip = True
    camera.start_preview()

    time.sleep(10) 
    subprocess.call("cd /srv/photobooth/source && gphoto2 --capture-image-and-download -F 4 -I 5", stderr=subprocess.STDOUT, shell=True)
    ###camera.stop_preview()

    print "Printing Please wait"
    subprocess.call("/srv/photobooth/scripts/assemble_and_print.sh", shell=True)
    camera.stop_preview()
    camera.close()

  else:
    print "There was an error exiting now"
    sys.exit(0) 
