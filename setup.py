#to send a file of gcode to the printer
# import sys
# 
# sys

# print(pwd)

import atexit
import os
import sys
sys.path.append(os.getcwd())
# sys.path.append("/usr/local/lib/python3.5")
import time
# from neopixel import *

from printrun.printcore import printcore
from printrun import gcoder
p=printcore()


def connect_board(port):
  p.connect(port,115200)
  p._listen_until_online()
  print(p.printer)

def close_connections():
  p.disconnect()
  time.sleep(0.1)
  print(p.printer)

def send_gcode(file):
  print(p.printer)
  # time.sleep(1)
  gcode=[i.strip() for i in open(file)] # or pass in your own array of gcode lines instead of reading from a file
  gcode = gcoder.LightGCode(gcode)
  p.startprint(gcode)
  while p.printing:
    time.sleep(0.1)


def send_cmd(cmd):
  p.send_now(cmd)

def cancelprint():
  print("stop print")
  p.cancelprint()
  


# # LED strip configuration:
# LED_COUNT      = 16      # Number of LED pixels.
# LED_PIN        = 18      # GPIO pin connected to the pixels (must support PWM!).
# LED_FREQ_HZ    = 800000  # LED signal frequency in hertz (usually 800khz)
# LED_DMA        = 10      # DMA channel to use for generating signal (try 10)
# LED_BRIGHTNESS = 255     # Set to 0 for darkest and 255 for brightest
# LED_INVERT     = False   # True to invert the signal (when using NPN transistor level shift)
# LED_CHANNEL    = 0
# LED_STRIP      = ws.SK6812_STRIP_RGBW
# #LED_STRIP      = ws.SK6812W_STRIP
# strip = Adafruit_NeoPixel(LED_COUNT, LED_PIN, LED_FREQ_HZ, LED_DMA, LED_INVERT, LED_BRIGHTNESS, LED_CHANNEL, LED_STRIP)
# # Intialize the library (must be called once before other functions).
# strip.begin()
# 
# 
# # Define functions which animate LEDs in various ways.
# def colorWipe(number=0, wait_ms=50):
# 	"""Wipe color across display a pixel at a time."""
# 	color = Color(number,number,number,number)
# 	for i in range(strip.numPixels()):
# 		strip.setPixelColor(i, color)
# 		strip.show()
# 		time.sleep(wait_ms/1000.0)



atexit.register(close_connections)
