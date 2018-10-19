import gcodes as GCODES
from band_config import BandConfig
from plate_config import Plate
from print_head_config import PrinterHead

class SampleApplicationDriver:

    BAND_CONFIG_DEFAULT = [{ 
    'nozzle_id': 1,
    'label': "Wasser aus der Lahn",
    'volume_set': "0.034"
    },{ 
        'nozzle_id': 2,
        'label': "Wasser aus der Leitung",
        'volume_set': "0.068"
    }]

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


    
    
    def __init__(self, communication, band_config=BAND_CONFIG_DEFAULT , \
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

        calibration_x = calibration_x
        calibration_y = calibration_y
        self.plate = Plate(plate_config, calibration_x, calibration_y)
        self.printer_head = PrinterHead(head_config)
        self.band_config = BandConfig(band_config, self.printer_head, self.plate)
        self.communication = communication

    def set_configs(self, band_config=BAND_CONFIG_DEFAULT , \
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
