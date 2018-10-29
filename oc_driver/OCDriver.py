from FineControlDriver import FineControlDriver
from SampleApplicationDriver  import SampleApplicationDriver 

from communication import Communication

    # TODO default values!

DEFAULT_CONFIG = {
    'connection_string': "/dev//ttyACM0",
    'baud_rate': 115200,
    'calibration_x': 1,
    'calibration_y': 10,
    'dpi': 96
}


class OCDriver:
    INCHE = 25.4
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
        self.config['reso'] = round(self.INCHE / self.config['dpi'], 3)

        

    
    def get_sample_application_driver(self):
        return SampleApplicationDriver(communication=self.communication, \
                 calibration_x=self.config.get('calibration_x'), \
                 calibration_y=self.config.get('calibration_y'))
    

                           
    def get_fine_control_driver(self, printer_head_config):
        
        self.fine_control_driver = FineControlDriver(self.communication, printer_haed_config)
        
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


        
