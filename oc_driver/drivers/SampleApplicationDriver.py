import drivers.gcodes as GCODES
from drivers.abstract_application_driver.AbstractApplicationDriver import AbstractApplicationDriver

class SampleApplicationDriver(AbstractApplicationDriver):

    
    PLATE_CONFIG_DEFAULT = {
        'gap': 2,
        'plate_width_x': 100,
        'plate_height_y': 100,
        'band_length': 6,
        'relative_band_distance_x': 10,
        'relative_band_distance_y': 10
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
        super(SampleApplicationDriver, self) \
            .__init__(communication, plate_config, head_config, calibration_x, calibration_y)



    def generate_gcode(self):
        gcode_start = GCODES.start(self.printer_head.get_speed(), self.plate.get_band_offset_y())
        gcode_for_bands = self.band_config.to_gcode()
        gcode_end = GCODES.END
        return (gcode_start + "\n" + gcode_for_bands + "\n" + gcode_end)    

    def get_default_printer_head_config(self):
        return self.HEAD_CONFIG_DEFAULT

    def get_default_plate_config(self):
        return self.PLATE_CONFIG_DEFAULT
