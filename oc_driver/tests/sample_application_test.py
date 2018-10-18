import unittest
from oc_driver import OCDriver

BAND_CONFIG_DEFAULT = [{ 
    'nozzle_id': 1,
    'label': "Wasser aus der Lahn",
    'volume_set': "1"
},{ 
    'nozzle_id': 2,
    'label': "Wasser aus der Leitung",
    'volume_set': "2"
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
        'printer_head_resolution': 0.1,
        'step_range': 0.1
}

class TestSampleApplication(unittest.TestCase):
    def test_initialization_works(self):
        driver = OCDriver.OCDriver()
        driver.get_sample_application_driver(BAND_CONFIG_DEFAULT, PLATE_CONFIG_DEFAULT, HEAD_CONFIG_DEFAULT)
        
        
