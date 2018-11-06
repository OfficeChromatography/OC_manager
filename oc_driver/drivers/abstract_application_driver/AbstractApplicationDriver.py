from abc import ABCMeta, abstractmethod
import oc_driver.drivers.gcodes as GCODES
from oc_driver.config.band_config import BandConfig
from oc_driver.config.plate_config import Plate
from oc_driver.config.print_head_config import PrinterHead

class AbstractApplicationDriver:
    __metaclass__ = ABCMeta


    CREATE_BAND_CONFIG = {
        "default_nozzle_id": 1,
        'default_label': "Band",
        "number_of_bands": 3
    }
    
    def __init__(self, communication, plate_config, head_config, calibration_x, calibration_y):
        self.calibration_x = calibration_x
        self.calibration_y = calibration_y
        self.setup(plate_config, head_config)
        self.communication = communication

    def setup(self, plate_config=None, head_config=None):
        if plate_config:
            self.plate = Plate(plate_config, self.calibration_x, self.calibration_y)
        if head_config:
            self.printer_head = PrinterHead(head_config)
        self.band_config = self.create_band_config()    

    def create_band_config(self, number_of_bands=CREATE_BAND_CONFIG['number_of_bands']):
        create_conf = self.CREATE_BAND_CONFIG
        create_conf['number_of_bands'] = int(number_of_bands)
        self.band_config = BandConfig(create_conf, self.printer_head, self.plate)
        return self.band_config

    def set_band_config(self, band_list):
        self.band_config.band_list_to_bands(band_list)

    def update_band_list(self, band_list):
        self.band_config.band_list_to_bands(band_list)
        update_band_list = self.band_config.to_band_list()
        return update_band_list

    def volume_per_band(self):
        "how much volume should be applied on a single band"
        return self.plate.get_band_length() / \
                  self.printer_head.get_step_range()  * \
                  self.printer_head.get_number_of_fire() * \
                  self.plate.get_drop_volume()  / 1000
    
    def generate_gcode_and_send(self):
        gcode = self.generate_gcode()
        gcode_list = gcode.split('\n')
        self.communication.send(gcode_list)

    def control_configs (self, number_of_bands):
        plate = self.plate
        plate_width_x = plate.get_plate_width_x()
        track_length = plate.get_band_length() + plate.get_gap()
        offset = plate.get_offset_x()
        
    
    @abstractmethod
    def generate_gcode(self):
        pass

    @abstractmethod    
    def get_default_printer_head_config(self):
        pass

    @abstractmethod
    def get_default_plate_config(self):
        pass
