from FineControlDriver import FineControlDriver
from SampleApplicationDriver import SampleApplicationDriver 
from communication import Communication


DEFAULT_CONFIG = {
    'connection_string': "/dev//ttyACM0",
    'baud_rate': 115200,
    'drop_vol': 0.15,
    'xlevel': 1,
    'ylevel': 10,
    'inche': 25.4,
    'dpi': 96,
    'visu_roi':  "0.25,0.2,0.6,0.6"
}

class OCDriver:

    def __init__(self, oc_driver_config=DEFAULT_CONFIG):
        """
        CONNECTION_STRING
        baud_rat
        Drop_vol # in nL, use to calculate volume in Methods
        xlevel
        ylevel
        inche # mm/inche
        dpi # resolution of the Hp cartdrige (datasheet), dpi=number/inch
        # distance of one nozzle to the next one  round(inche/dpi,3)
        visu_roi
        """
        self.communication = Communication(oc_driver_config['connection_string'],
                                           oc_driver_config['baud_rate'])
        self.config = oc_driver_config
        self.config['reso'] = round(self.config['inche'] / self.config['dpi'], 3)
        self.fine_control_driver = FineControlDriver(self.communication)
        self.sample_application_driver = SampleApplicationDriver(self.communication, self.config)

    def get_sample_application_driver(self):
        return self.sample_application_driver
        
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

    def pause(self):
        self.communication.pause()

    def stop(self):
        self.communication.stop()

    def resume(self):
        self.communication.resume()


        
