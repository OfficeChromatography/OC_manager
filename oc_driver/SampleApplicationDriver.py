import gcodes as GCODES
from band_config import BandConfig
from plate_config import Plate
from print_head_config import PrinterHead

class SampleApplicationDriver:

    CREATE_BAND_CONFIG = {
        "default_nozzle_id": 1,
        'default_label': "Band",
        "number_of_bands": 3
    }
    
    PLATE_CONFIG_DEFAULT = {
        'gap': 2,
        'plate_width_x': 100,
        'plate_height_y': 100,
        'band_length': 6,
        'relative_band_distance_x': 10,
        'relative_band_distance_y': 10,
        'drop_vol' : 0.15,
    }


    HEAD_CONFIG_DEFAULT = {
        'speed': 3000,
        'number_of_fire': 10,
        'pulse_delay': 5,
        'printer_head_resolution': 0.265,
        'step_range': 0.265
    }


    
    
    def __init__(self, communication,
                 plate_config=PLATE_CONFIG_DEFAULT, \
                 head_config=HEAD_CONFIG_DEFAULT, calibration_x=1, calibration_y=10):
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

        self.calibration_x = calibration_x
        self.calibration_y = calibration_y
        self.setup(plate_config, head_config)
        self.communication = communication

    def setup(self, plate_config, head_config):
        self.plate = Plate(plate_config, self.calibration_x, self.calibration_y)
        self.printer_head = PrinterHead(head_config)
        self.band_config = self.create_band_config()
        
        
    def create_band_config(self, number_of_bands=CREATE_BAND_CONFIG['number_of_bands']):
        create_conf = self.CREATE_BAND_CONFIG
        create_conf['number_of_bands'] = int(number_of_bands)
        self.band_config = BandConfig(create_conf, self.printer_head, self.plate)
        return self.band_config

    def set_band_config(self, band_list):
        self.band_config.band_list_to_bands(band_list)
        
    def get_default_printer_head_config(self):
        return self.HEAD_CONFIG_DEFAULT

    def get_default_plate_config(self):
        return self.PLATE_CONFIG_DEFAULT
           
    def _set_configs(self, band_config=CREATE_BAND_CONFIG , \
                 plate_config=PLATE_CONFIG_DEFAULT, \
                 head_config=HEAD_CONFIG_DEFAULT):
        calibration_x = self.plate.get_calibration_x()
        calibration_y = self.plate.get_calibration_y()
        self.plate =  Plate(plate_config, calibration_x, calibration_y)
        self.printer_head = PrinterHead(head_config)
        self.band_config = BandConfig(band_config, self.printer_head, self.plate)
        
    def generate_gcode(self):

        gcode_end = GCODES.END
        gcode_start = GCODES.start(self.printer_head.get_speed(), self.plate.get_band_offset_x())
        gcode_for_bands = self.band_config.to_gcode()
        return (gcode_start + "\n" + gcode_for_bands + "\n" + gcode_end)


    def generate_gcode_and_send(self):
        gcode = self.generate_gcode()
        self.communication.send(gcode)
    
    
    def volume_per_band(self):
        "how much volume should be applied on a single band"
        return self.plate.get_band_length() / \
                  self.printer_head.get_step_range()  * \
                  self.printer_head.get_number_of_fire() * \
                  self.plate.get_drop_volume()  / 1000
