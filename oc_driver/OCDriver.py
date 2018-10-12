from printrun import printcore, gcoder

import time

from FineControlDriver import FineControlDriver


class OCDriver:
    def __init__(self, connectionString, baudRate):        
         self.printcore = printcore.printcore()
         self.connectionString = connectionString
         self.baudRate = baudRate
         self.fine_control_driver = FineControlDriver(self.printcore)

    def connect(self):
         self.printcore.connect(self.connectionString, self.baudRate)
         self.printcore.listen_until_online()
         
         
    def get_fine_control_driver(self):
         return self.fine_control_driver

    def is_connected(self):
         return self.printcore.online

    def disconnect(self):
        self.printcore.disconnect()

    def send_light_gcode_from_file(self, file):
        gcode=[i.strip() for i in open(file)] # or pass in your own array of gcode lines instead of reading from a file
        gcode = gcoder.LightGCode(gcode)
        self.printcore.startprint(gcode)
        while (self.printcore.printing):
            time.sleep(0.1)


        
    
