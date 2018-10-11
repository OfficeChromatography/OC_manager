from printrun import printcore

from FineControlDriver import FineControlDriver


class OCDriver:
    def __init__(self, connectionString, baudRate):        
         self.printcore = printcore.printcore()
         self.printcore.connect(connectionString, baudRate)
         self.printcore.listen_until_online()
         self.fine_control_driver = FineControlDriver(self.printcore)
        


    def get_fine_control_driver(self):
        return self.fine_control_driver
