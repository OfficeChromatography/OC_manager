import logging
import unittest
from oc_driver import OCDriver
from types import StringType
import codecs
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

def gen_default_gcode():
    driver = OCDriver.OCDriver()
    app_driver = driver.get_sample_application_driver()
    return app_driver.generate_gcode()


def load_test_gcode():
    gcode_file = open("./tests/default_gcode.txt", 'r')
    return gcode_file.read().replace('\r', '')

class TestSampleApplication(unittest.TestCase):
    
    def test_initialization_works(self):
        gcode = gen_default_gcode()
        assert type(gcode) is StringType

    def test_default_gcode_works_as_expected(self):
        gcode = gen_default_gcode()
        correct_gcode = load_test_gcode()
        self.assertEquals(gcode.strip(), correct_gcode.strip())


    def test_override_config_works(self):
        driver = OCDriver.OCDriver()
        app_driver = driver.get_sample_application_driver()
        app_driver.set_configs(BAND_CONFIG_DEFAULT, PLATE_CONFIG_DEFAULT, HEAD_CONFIG_DEFAULT )
        gcode = app_driver.generate_gcode()
        correct_gcode = load_test_gcode()
        self.assertEquals(gcode.strip(), correct_gcode.strip())
        

if __name__ == "__main__":
    unittest.main()
