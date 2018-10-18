from oc_driver import gcodes as GCODES
from oc_driver.band_config import BandConfig

class SampleApplicationDriver:

    def __init__(self, communication, band_config_dict, plate, printer_head):
        self.communication = communication
        self.plate = plate
        self.printer_head = printer_head
        self.band_config = BandConfig(band_config_dict, printer_head, plate)
        
    def generate_gcode(self):

        gcode_end = GCODES.END
        gcode_start = GCODES.start(self.printer_head.get_speed(), self.plate.get_band_offset_x())
        gcode_for_bands = self.band_config.to_gcode()
        return GCODES.new_lines(gcode_start, gcode_for_bands, gcode_end)       
