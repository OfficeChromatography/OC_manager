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

    def update_settings (self, plate_config=PLATE_CONFIG_DEFAULT,
                         head_config = HEAD_CONFIG_DEFAULT,
                         band_config = None,
                         number_of_bands = 1):
        if not band_config:
            band_config = self.create_band_list(number_of_bands)
        
        self.update_plate_and_head_configs_to_driver(plate_config, head_config)
        self.band_config.update_plate_and_head_configs_to_bands(self.plate, self.printer_head)
        new_band_list = self.add_or_remove_Bands(number_of_bands,band_config)
        return self.create_bands_from_config(new_band_list)

    def add_or_remove_Bands(self, number_of_bands, old_band_config):
        difference = int (number_of_bands - len (old_band_config))
        new_band_config = old_band_config
        if difference > 0 :
            new_band_config = self.add_Bands(old_band_config, difference)
        elif difference < 0:
            new_band_config = self.remove_Bands(old_band_config, int (number_of_bands) )
        return new_band_config

    def add_Bands(self,old_band_config,number_of_bands_to_add):
        new_bands = self.create_band_list(number_of_bands_to_add)
        new_band_config = old_band_config + new_bands
        return new_band_config

    def remove_Bands(self, old_band_config, number_of_bands):
        new_band_config = old_band_config[0:number_of_bands]
        return new_band_config
