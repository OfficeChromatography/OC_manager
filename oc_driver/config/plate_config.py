
class Plate:
    def __init__(self, plate_config, calibration_x, calibration_y):
        """

        This class represents the configuration of the OC-plate 

        plate_config: dict {
        'gap': number,              
        'plateX': number,           
        'plateY': number,           
        'band_length': number,      
        'relative_band_distance_y': number,           
        'relative_band_distance_x': number,                     
        """
        ## x direction of the axis = y direction  of the plate
        ## y direction of the axis = x direction  of the plate
        self.calibration_x = calibration_y
        self.calibration_y = calibration_x 

        
        self.gap = float(plate_config.get('gap'))
        self.plate_width_x = float(plate_config.get('plate_width_x'))
        self.plate_height_y = float(plate_config.get('plate_height_y'))
        self.relative_band_distance_x =float( plate_config.get('relative_band_distance_x')  )
        self.relative_band_distance_y = float(plate_config.get('relative_band_distance_y') )
        self.band_length = float(plate_config.get('band_length'))

    def get_calibration_x(self):
        return self.calibration_x
    
    def get_calibration_y(self):
        return self.calibration_y

    def get_relative_band_distance_x(self):
        return self.relative_band_distance_x

    def get_relative_band_distance_y(self):
        return self.relative_band_distance_y
    
    def get_band_offset_x(self):
        'band offset from the plate in x direction'
        return self.calibration_x + \
            self.relative_band_distance_x + 50 - \
            self.plate_width_x / 2

    def get_gap(self):
        "Gap between bands"
        return self.gap
    
    def get_band_offset_y(self):
        'band offset from the plate in y direction'
        return self.calibration_y + \
            self.relative_band_distance_y + 50 - \
            self.plate_height_y / 2

    def get_band_length(self):
        return self.band_length

    def set_band_offset_y(self, band_offset_y):
        self.band_offset_y = float (band_offset_y)

    def get_plate_width_x(self):
        return self.plate_width_x

    def get_plate_height_y(self):
        return self.plate_height_y

    def set_band_length(self,band_length):
        self.band_length = band_length
