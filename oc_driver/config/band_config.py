import drivers.gcodes as GCODES 
import numpy as np

class Band:
    def __init__(self, start, end, number_of_reptitions, drop_volume, \
                 label, volume_set, nozzle_id, volume_real):
        self.volume_real = volume_real
        self.nozzle_id = nozzle_id
        self.volume_set = volume_set
        self.start = start
        self.end = end
        self.number_of_reptition = number_of_reptitions
        self.label = label
        self.drop_volume = drop_volume

    def get_number_of_repitition(self):
        "how often should one band be applied"
        return self.number_of_reptition

    def get_start(self):
        "3d-printer position for band start"
        return self.start

    def get_end(self):
        "3d-printer position for band end"
        return self.end

    def get_drop_volume (self):
        return self.drop_volume

    def get_nozzle_id(self):
        return self.nozzle_id

    def set_nozzle_id(self, nozzle_id):
        self.nozzle_id = nozzle_id
        
    def set_number_of_reptition(self, number_of_reptition):
        self.number_of_reptition = number_of_reptition
        
    def to_dict(self):
        return {'start': self.start, 'end': self.end, 'drop_volume': self.drop_volume,                         'label' : self.label, 'nozzle_id': self.nozzle_id, \
                'volume_set': self.volume_set, 'volume_real': self.volume_real}
    
    
class BandConfig:
    def __init__(self, create_config,  printer_head, plate):
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
        band_list = self.create_conf_to_band_list(create_config)        
        self.build_bands_from_band_list(band_list)

    def band_list_to_bands(self, band_list):
        self.build_bands_from_band_list(band_list)
        
    def create_conf_to_band_list(self, create_config):
        "Transforms the create_config into a list list"
        bands = []
        number_of_bands = int(create_config['number_of_bands'])
        drop_volume = float (create_config['drop_volume'])
        for i in range(number_of_bands):
            bands.append({
                'nozzle_id' : create_config['default_nozzle_id'],
                'label' : create_config['default_label'],
                'drop_volume' : drop_volume,
                'volume_set': round(self.volume_per_band(drop_volume),3)
            })
        return bands

    def volume_per_band(self, drop_volume):
        "how much volume should be applied on a single band"
        return self.plate.get_band_length() / \
                  self.printer_head.get_step_range()  * \
                  self.printer_head.get_number_of_fire() * \
                  drop_volume  / 1000

    def calculate_band_end_from_start(self, start):
        "aux function to calculate the next 3d printer end pos"
        return start + self.plate.get_band_length()

    def calculate_number_of_reps(self, volume_set, volume_per_band):
        "Calculates the number of application per band by a given volume"
        return round(float(volume_set) / volume_per_band )

    def calculate_volume_real(self, number_of_reptitions, volume_per_band):
        "Calculates the applied volume depending on volume_per_band"
        return round(number_of_reptitions * volume_per_band, 3)

    def calculate_start_positions(self, number_of_bands):
        start = self.plate.get_band_offset_x()
        plate = self.plate 
        start_pos_list = [start]
        for i in range(number_of_bands):
            start += plate.get_band_length() + plate.get_gap()
            start_pos_list.append(start)
        return start_pos_list
    
    def build_bands_from_band_list(self, band_list):
        "initializes all bands given by a band configuration"
        if len(band_list) <= 0:
            return 
        bands = []
        band_start_list = self.calculate_start_positions(len(band_list))
        for idx, band_config in enumerate(band_list):
            nozzle_id = int(band_config.get('nozzle_id'))
            shift = self.printer_head.get_shift_for_nozzle(nozzle_id)
            band_start = band_start_list[idx] + shift
            band_end = self.calculate_band_end_from_start(band_start)
            volume_set = float(band_config.get('volume_set'))
            drop_volume = float (band_config.get('drop_volume'))
            volume_per_band = self.volume_per_band(drop_volume)
            number_of_reptitions = self.calculate_number_of_reps(volume_set, volume_per_band)
            volume_real = self.calculate_volume_real(number_of_reptitions, volume_per_band)
            label = str(band_config.get('label'))
            
            # add new band
            bands.append(Band(band_start, band_end, number_of_reptitions, drop_volume, \
                              label, volume_set, nozzle_id, volume_real))
        self.bands = bands
        
    def to_band_list(self):
        band_list = []
        for band in self.bands:
            band_list.append(band.to_dict())
        return band_list
            
    
    def to_gcode(self):
        "generates the gcode containing commands for applying bands of liquid on a plate"
        fire_rate = self.printer_head.get_number_of_fire()
        pulse_delay = self.printer_head.get_pulse_delay()
        step_range = self.printer_head.get_step_range()
        gcode = []
        for idx, band in enumerate(self.bands):
            gcode_band = []
            start = band.get_start()
            end = band.get_end()
            drops = np.arange(start, end + step_range, step_range)
            nozzle_id = band.get_nozzle_id()
            address = self.printer_head.get_address_for_nozzle(nozzle_id)
            for drop_position in drops:
                drop_position_round = round(drop_position,3)
                gcode_band.append(GCODES.goYPlus(drop_position_round))
                gcode_band.append(GCODES.nozzle_fire(fire_rate, address, pulse_delay))
            gcode = gcode + gcode_band * int(band.get_number_of_repitition()) 
                
        return GCODES.new_lines(gcode)

    def get_bands(self):
        return self.bands
