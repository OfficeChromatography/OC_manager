#!/usr/bin/env python
"""
Simple g-code streaming script for grbl
https://onehossshay.wordpress.com/2011/08/26/grbl-a-simple-python-interface/
"""
y=5
import serial
import time
import atexit

# open the camera
# camera = PiCamera()

def connect_board(port):
    global s
    
    # Open grbl serial port
    s = serial.Serial(port,115200)
    
    # Wake up grbl
    s.write("\r\n\r\n")
    time.sleep(2)   # Wait for grbl to initialize
    s.flushInput()  # Flush startup text in serial input



# Close file and serial port
def close_connections():
  if s.isOpen():
    s.close()
    # camera.close()
    

    
def send_cmd(cmd):
    cmd = str(cmd)
    cmd = cmd.strip()
    print "Sending: " + cmd
    cmd = cmd.split(";")[0]
    s.write(cmd + '\n') # Send g-code block to grbl
    grbl_out = s.readline() # Wait for grbl response with carriage return
    print ' : ' + grbl_out.strip()
    return(grbl_out) # Wait for grbl response with carriage return
    
def send_gcode(file = ""):
    f = open(file,'r'); 
    # Stream g-code to grbl
    for line in f:
        l = line.strip() # Strip all EOL characters for streaming
        print 'Sending: ' + l,
        l = l.split(";")[0]
        s.write(l + '\n') # Send g-code block to grbl
        grbl_out = s.readline() # Wait for grbl response with carriage return
        print ' : ' + grbl_out.strip()
    f.close()

# Wait here until grbl is finished to close serial port and file.
#raw_input("  Press <Enter> to exit and disable grbl.")

def get_temp():
    s.write("M105" + '\n') # Send g-code block to grbl
    return(s.readline()) # Wait for grbl response with carriage return
    
def set_temp(temp):
    truc = "M140 S" +str(temp) + '\n'
    print(truc)
    s.write(truc) # Send g-code block to grbl
    # return(s.readline()) # Wait for grbl response with carriage return
    
def M112():
    s.write("M112")
    
def extrude(x):
    # truc = "G1 E" +str(x) + '\n'
    print(truc)
    s.write(truc) # Send g-code block to grbl
    return(s.readline()) # Wait for grbl response with carriage return



    
def Visu_take(file): ## done direct with raspistill from R
    camera.start_preview()
    time.sleep(2)
    camera.capture(file)
    camera.stop_preview()

def test_stop():
    for x in range(0, 60):
        print("test_stop")
        time.sleep(1)

    
    
def GPIO7_on():
    # from picamera import PiCamera
    import RPi.GPIO as GPIO ## Import GPIO library
    GPIO.setmode(GPIO.BOARD) ## Use board pin numbering
    GPIO.setup(7, GPIO.OUT) ## Setup GPIO Pin 7 to OUT
    # GPIO.output(7,False) ## Turn on GPIO pin 7
    GPIO.output(7, True)


def GPIO7_off():
    # from picamera import PiCamera
    import RPi.GPIO as GPIO ## Import GPIO library
    GPIO.setmode(GPIO.BOARD) ## Use board pin numbering
    GPIO.setup(7, GPIO.OUT) ## Setup GPIO Pin 7 to OUT
    # GPIO.output(7,False) ## Turn on GPIO pin 7
    GPIO.output(7, False)

atexit.register(close_connections)
