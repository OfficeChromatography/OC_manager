from printrun import printcore, gcoder
import time


class OCDriver:
    def __init__(self, connectionString, baudRate):        
         self.printcore = printcore.printcore()
         self.connectionString = connectionString
         self.baudRate = baudRate

    def connect(self):
         self.printcore.connect(self.connectionString, self.baudRate)
         self.printcore.listen_until_online()

    def is_connected(self):
         return self.printcore.online

    def disconnect(self):
        self.printcore.disconnect()

    def send_light_gcode_from_file(self, file):
        print (gcoder)
        gcode=[i.strip() for i in open(file)] # or pass in your own array of gcode lines instead of reading from a file
        self.send(gcode)
        # while (self.printcore.printing):
        #    time.sleep(0.1)
    
    
    def send(self, codes):
        gcode = gcoder.LightGCode(codes)    
        is_printing = OCDriver.printcore.startprint(codes)
        if(is_printing):
            print ("Start printing...")
        else:
            print ("Cannot print...")

        
    
