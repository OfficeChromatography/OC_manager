from oc_driver import FineControlDriver
from oc_driver import SampleApplicationDriver 
from oc_driver.plate_config import Plate
from oc_driver.communication import Communication
from oc_driver.print_head_config import PrinterHead
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
        self.fine_control_driver = FineControlDriver.FineControlDriver(self.communication)
        

    
    def get_sample_application_driver(self, band_config, plate_config, head_config):
        """
        plate_config: dict {
        'gap': number,              plate
        'plateX': number,           plate
        'plateY': number,           plate
        'bandLength': number,       plate
        'distY': number,            plate
        'distX': number,            plate 
        'drop_vol' : float          plate }

        head_config: dict {
        'speed': number,            head
        'numberOfFire': number,     head
        'pulseDelay': number,       head
        }
        """
        calibration_x = self.config.get('calibration_x')
        calibration_y = self.config.get('calibration_y')
        plate = Plate(plate_config, calibration_x, calibration_y)

        printer_head = PrinterHead(head_config)
        return SampleApplicationDriver.SampleApplicationDriver(self.communication, band_config, plate, printer_head)
    

                           
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


        
