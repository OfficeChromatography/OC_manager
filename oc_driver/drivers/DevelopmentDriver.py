import drivers.gcodes as GCODES
from drivers.abstract_application_driver.AbstractApplicationDriver import AbstractApplicationDriver

class DevelopmentDriver(AbstractApplicationDriver):

    
    PLATE_CONFIG_DEFAULT = {
        'gap': 0,
        'plate_width_x': 100,
        'plate_height_y': 100,
        'band_length': 80,
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
        super(DevelopmentDriver, self) \
            .__init__(communication, plate_config, head_config, calibration_x, calibration_y)


    def calculate_band_length (self):
        band_length = self.plate.get_plate_width_x() - 2 * self.plate.get_relative_band_distance_x()
        self.plate.set_band_length(band_length)

    def generate_gcode(self):
        gcode_start = GCODES.start(self.printer_head.get_speed(), self.plate.get_band_offset_y())
        gcode_for_bands = self.band_config.to_gcode()
        gcode_end = GCODES.END
        return (gcode_start + "\n" + gcode_for_bands + "\n" + gcode_end)    

    def get_default_printer_head_config(self):
        return self.HEAD_CONFIG_DEFAULT

    def get_default_plate_config(self):
        return self.PLATE_CONFIG_DEFAULT

    def get_band_length(self):
        return self.plate.get_band_length()

    def update_settings (self, plate_config=PLATE_CONFIG_DEFAULT,
                         head_config = HEAD_CONFIG_DEFAULT,
                         band_config = None):
        if not band_config:
            band_config = self.create_band_list(1)
        self.update_plate_and_head_configs_to_driver(plate_config, head_config)
        self.calculate_band_length()
        return self.create_bands_from_config(band_config)
