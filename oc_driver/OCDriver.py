from FineControlDriver import FineControlDriver
from communication import Communication

class OCDriver:
    def __init__(self, connection_string, baud_rate):        
        self.communication = Communication(connection_string, baud_rate)
        self.fine_control_driver = FineControlDriver(self.communication)

    def get_fine_control_driver(self):
        return self.fine_control_driver
        
    def connect(self):
        self.communication.connect()

    def is_connected(self):
        return self.communication.printcore.online

    def disconnect(self):
        self.communication.disconnect()

    def send_from_file(self, path):
        self.communication.send_from_file(path)
        # while (self.printcore.printing):
        #    time.sleep(0.1)
