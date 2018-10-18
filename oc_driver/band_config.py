from oc_driver import gcodes as GCODES 
import numpy as np

class Band:
    def __init__(self, start, end, number_of_reptitions, label):
        self.start = start
        self.end = end
        self.number_of_reptition = number_of_reptitions
        self.label = label

    def get_number_of_repitition(self):
        "how often should one band be applied"
        return self.number_of_reptition

    def get_start(self):
        "3d-printer position for band start"
        return self.start

    def get_end(self):
        "3d-printer position for band end"
        return self.end
    
    
class BandConfig:
    def __init__(self, band_config_dict, printer_head, plate):
        """

        represents which band should use which nozzle in order to apply a given ammount 
        of a discrete liquid

        band_config_dict :  [{
          nozzle_id: integer,
          label: str,
          volume_set: float    
        }, ....]
        """
        self.printer_head = printer_head
        self.plate = plate
        self.band_config = band_config_dict
        self.init_bands()

    def volume_per_band(self):
        "how much volume should be applied on a single band"
        return self.plate.get_band_length() / \
                  self.printer_head.get_step_range()  * \
                  self.printer_head.get_number_of_fire() * \
                  self.plate.get_drop_volume()  / 1000

    def calculate_band_end_from_start(self, start):
        "aux function to calculate the next 3d printer end pos"
        return start + self.plate.get_band_length() + self.plate.get_gap()

    def calculate_band_start(self, start, band_config):
        "aux function to calculate the next 3d printer start pos"
        nozzle_id = band_config.get('nozzle_id')
        shift = self.printer_head.get_shift_for_nozzle(nozzle_id)
        return (start + self.plate.get_band_offset_y() + shift)

    def calculate_number_of_reps(self, band_config):
        "Calculates the number of application per band by a given volume"
        volume_set = band_config.get('volume_set')
        return round(volume_set / self.volume_per_band())
        
    
    def init_bands(self):
        "initializes all bands given by a band configuration"
        bands = []
        BEGIN_POS = 0
        band_start = self.calculate_band_start(BEGIN_POS, self.band_config[0])
        band_end = self.calculate_band_end_from_start(band_start)
        for band_config in self.band_config:
            number_of_reptitions = self.calculate_number_of_reps(band_config)
            label = band_config.get('label')
            # add new band
            bands.append(Band(band_start, band_end, number_of_reptitions, label))
            band_start = self.calculate_band_start(band_start, band_config)
            band_end = self.calculate_band_end_from_start(band_start)
        self.bands = bands
            
    
    def to_gcode(self):
        "generates the gcode containing commands for applying bands of liquid on a plate"
        step_width = self.plate.get_band_length / self.printer_head.get_resolution()
        fire_rate = self.printer_head.get_number_of_fire()
        pulse_delay = self.printer_head.get_pulse_delay()
        gcode = []
        for idx, band in self.bands:
            start = band.get_start()
            end = band.get_end()
            drops = np.arange(start, end, step_width)
            nozzle_id = self.band_config[idx].get('nozzle_id')
            address = self.printer_head.get_address_for_nozzle(nozzle_id)
            for drop_position in drops:
                gcode.append(GCODES.goYPlus(drop_position))
                gcode.append(GCODES.fire(fire_rate, address, pulse_delay))
            gcode = gcode * band.get_number_of_repitition()
                
        return gcode
