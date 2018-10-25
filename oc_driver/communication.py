from printrun import printcore, gcoder

import time

class Communication:
    def __init__(self, connection_string, baud_rate):
        self.connection_string = connection_string
        self.baud_rate = baud_rate
        self.printcore = printcore.printcore()

    def pause(self):
        self.printcore.pause()

    def stop(self):
        self.printcore.stop()

    def resume(self):
        self.printcore.resume()
        
    def connect(self):
        self.printcore.connect(self.connection_string, self.baud_rate)
        self.printcore.listen_until_online()
        
    def is_connected(self):
        return self.printcore.online
        
    def disconnect(self):
        self.printcore.disconnect()
        
    def send_from_file(self, path):
        with open(path, 'r') as gcode_file:
            content = gcode_file.read()
            self.send(content)
    
    
    def send(self, codes):
        split = codes.split('\n')
        no_spaces_code = [i.strip() for i in split]
        gcode = gcoder.LightGCode(no_spaces_code)
        is_printing = self.printcore.startprint(gcode)
        if(is_printing):
            print("Start printing...")
            while (self.printcore.printing):
                time.sleep(0.1)
            print("Printing finished!")
        else:
            print("Cannot print...")
            
