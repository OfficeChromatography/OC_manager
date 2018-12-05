from abc import ABCMeta, abstractmethod
import drivers.gcodes as GCODES
from config.band_config import BandConfig
from config.plate_config import Plate
from config.print_head_config import PrinterHead

class AbstractApplicationDriver:
    __metaclass__ = ABCMeta


    CREATE_BAND_CONFIG = {
        "default_nozzle_id": 1,
        'default_label': "Band",
        "number_of_bands": 3,
        "drop_volume": 0.15
    }
    
    def __init__(self, communication, plate_config, head_config, calibration_x, calibration_y):
        self.calibration_x = calibration_x
        self.calibration_y = calibration_y
        self.update_plate_and_head_configs(plate_config, head_config)
        self.communication = communication
        self.band_config = BandConfig(CREATE_BAND_CONFIG, self.printer_head, self.plate)

    def update_plate_and_head_configs(self, plate_config=None, head_config=None):
        if plate_config:
            self.plate = Plate(plate_config, self.calibration_x, self.calibration_y)
        if head_config:
            self.printer_head = PrinterHead(head_config)

    def add_or_remove_Bands(self, number_of_bands, old_band_config):
        difference = len (old_band_config) - number_of_bands
        if difference < 0 :
            new_band_config = self.add_Bands(old_band_config, difference)
        else if difference > 0:
            new_band_config = self.remove_Bands(old_band_config)
        else:
            new_band_config = old_band_config
        return new_band_config

    def add_Bands(self,old_band_config,number_of_bands_to_add):
        new_bands = self.create_band_list(number_of_bands_to_add)
        return old_band_config.append(new_bands)

    def remove_Bands(self, old_band_config, number_of_bands_to_remove):
        return del old_band_config[-number_of_bands_to_remove]
                   
    def create_band_list(self, number_of_bands=CREATE_BAND_CONFIG['number_of_bands']):
        create_conf = self.CREATE_BAND_CONFIG
        create_conf['number_of_bands'] = int(number_of_bands)
        return self.band_config.create_conf_to_band_list(create_conf)

    def create_bands_from_config(self, band_config):
        self.band_config.build_bands_from_band_list(band_list)
        return (self.band_config.to_band_list())

    def update_settings (self, plate_config, head_config, band_config, number_of_bands):
        self.update_plate_and_head_configs(plate_config, head_config)
        new_band_list = self.add_or_remove_Bands(number_of_bands,band_config)
        return self.create_bands_from_config(new_band_list) 
    
    def generate_gcode_and_send(self):
        gcode = self.generate_gcode()
        gcode_list = gcode.split('\n')
        self.communication.send(gcode_list)

    def start_application (self,band_list):
        self.set_band_config(band_list)
        self.generate_gcode_and_send()
    
    @abstractmethod
    def generate_gcode(self):
        pass

    @abstractmethod    
    def get_default_printer_head_config(self):
        pass

    @abstractmethod
    def get_default_plate_config(self):
        pass
