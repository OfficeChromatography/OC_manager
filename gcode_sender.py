#to send a file of gcode to the printer
import os
import sys
sys.path.append(os.getcwd())
import time

from printrun.printcore import printcore
from printrun import gcoder



def send_gcode(file, printer):
  # time.sleep(1)
  gcode=[i.strip() for i in open(file)] # or pass in your own array of gcode lines instead of reading from a file
  gcode = gcoder.LightGCode(gcode)
  printer.startprint(gcode)
  while (printer.printing):
      time.sleep(0.1)





