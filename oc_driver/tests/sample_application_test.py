import logging
import unittest
from oc_driver import OCDriver
from types import StringType
import codecs


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

def get_sample_application_driver():
    driver = OCDriver.OCDriver()
    return driver.get_sample_application_driver()

def gen_default_gcode():
    app_driver = get_sample_application_driver()
    return app_driver.generate_gcode()


def load_test_gcode():
    gcode_file = open("./tests/default_gcode.txt", 'r')
    return gcode_file.read().replace('\r', '')

def write_gcode_file(fN, code):
    f = open("./tests/"+fN, "w")
    f.write(code)

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
        app_driver._set_configs(CREATE_BAND_CONFIG, PLATE_CONFIG_DEFAULT, HEAD_CONFIG_DEFAULT )
        gcode = app_driver.generate_gcode()
        write_gcode_file("mygcode.txt", gcode)
        correct_gcode = load_test_gcode()
        self.assertEquals(gcode.strip(), correct_gcode.strip())

    def test_band_config_init_works(self):
        app_driver =  get_sample_application_driver()
        band_config = app_driver.create_band_config(5)
        band_list = band_config.to_band_list()
        self.assertEquals(len(band_list), 5)
        expected_band_list = [{'end': 28.915, 'volume_set': 0.03396226415094339,\
                               'label': 'Band', 'start': 22.915,\
                               'volume_real': 0.03396226415094339, 'nozzle_id': 1},\
                              {'end': 36.915, 'volume_set': 0.03396226415094339,\
                               'label': 'Band', 'start': 30.915,\
                               'volume_real': 0.03396226415094339, 'nozzle_id': 1},\
                              {'end': 44.915, 'volume_set': 0.03396226415094339,\
                               'label': 'Band', 'start': 38.915,\
                               'volume_real': 0.03396226415094339, 'nozzle_id': 1},\
                              {'end': 52.915, 'volume_set': 0.03396226415094339,\
                               'label': 'Band', 'start': 46.915,\
                               'volume_real': 0.03396226415094339, 'nozzle_id': 1},\
                              {'end': 60.915, 'volume_set': 0.03396226415094339,\
                               'label': 'Band', 'start': 54.915,\
                               'volume_real': 0.03396226415094339, 'nozzle_id': 1}]        
        self.assertEqual(band_list, expected_band_list)

    def test_band_config_update_works(self):
        app_driver =  get_sample_application_driver()
        band_config = app_driver.create_band_config(5)
        band_list = band_config.to_band_list()
        second_band = band_list[1]
        second_band['nozzle_id'] = 5
        band_list[1] = second_band
        band_config.band_list_to_bands(band_list)
        new_band_list = band_config.to_band_list()
        expected_band_list = [{
                                  'end':28.915,
                                  'volume_set':0.03396226415094339,
                                  'label':'Band',
                                  'start':22.915,
                                  'volume_real':0.03396226415094339,
                                  'nozzle_id':1
                              },
                              {
                                  'end':35.855000000000004,
                                  'volume_set':0.03396226415094339,
                                  'label':'Band',
                                  'start':29.855,
                                  'volume_real':0.03396226415094339,
                                  'nozzle_id':5
                              },
                              {
                                  'end':44.915,
                                  'volume_set':0.03396226415094339,
                                  'label':'Band',
                                  'start':38.915,
                                  'volume_real':0.03396226415094339,
                                  'nozzle_id':1
                              },
                              {
                                  'end':52.915,
                                  'volume_set':0.03396226415094339,
                                  'label':'Band',
                                  'start':46.915,
                                  'volume_real':0.03396226415094339,
                                  'nozzle_id':1
                              },
                              {
                                  'end':60.915,
                                  'volume_set':0.03396226415094339,
                                  'label':'Band',
                                  'start':54.915,
                                  'volume_real':0.03396226415094339,
                                  'nozzle_id':1
                              }]
        
        
        self.assertEqual(new_band_list, expected_band_list)

if __name__ == "__main__":
    unittest.main()
