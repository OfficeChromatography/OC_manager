
import gcodes as GCODES
from AbstractApplicationDriver import AbstractApplicationDriver

class FineControlDriver(AbstractApplicationDriver):

    PLATE_CONFIG_DEFAULT = {
        'gap': 2,
        'plate_width_x': 100,
        'plate_height_y': 100,
        'band_length': 6,
        'relative_band_distance_x': 0,
        'relative_band_distance_y': 0,
        'drop_vol' : 0.15,
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
        super(FineControlDriver, self) \
            .__init__(communication, plate_config, head_config, calibration_x, calibration_y)

    def goXLeft(self):
        self.communication.send( [
            GCODES.SET_REFERENCE,
            GCODES.goXMinus()
        ])
        
    def goXRight(self):
        self.communication.send( [
            GCODES.SET_REFERENCE,
            GCODES.goXPlus()
        ])
        

    def customCommand(self, command):
        self.communication.send([command])

    def goYHome(self):
        self.communication.send([
            GCODES.GO_TO_ORIGIN_Y,
            GCODES.SET_ABSOLUTE_POS
        ])

    def goXHome(self):
        self.communication.send([
            GCODES.GO_TO_ORIGIN_X,
            GCODES.SET_ABSOLUTE_POS
        ])

    def goYUp(self):
        self.communication.send( [
            GCODES.SET_REFERENCE,
            GCODES.goYPlus()
        ])
        
    def goYDown(self):
        self.communication.send( [
            GCODES.SET_REFERENCE,
            GCODES.goYMinus()
        ])

    def set_printer_head(self, printer_head_config):        
        self.setup(head_config=printer_head_config)

    def stop(self):
        return self.communication.send([GCODES.DISABLE_STEPPER_MOTORS])
    
    def fire_selected_nozzles(self, selected_nozzles):
        nozzle_address = self.calculate_nozzle_address_for_gcode(selected_nozzles)
        fire_rate = self.printer_head.get_number_of_fire()
        puls_delay = self.printer_head.get_pulse_delay()
        self.communication.send([
            GCODES.nozzle_fire(fire_rate, nozzle_address, puls_delay)
        ])

    def calculate_nozzle_address_for_gcode(self, selected_nozzles):
        nozzle_value = 0
        for nozzle in selected_nozzles:
            address_str = self.printer_head.get_address_for_nozzle(nozzle)
            nozzle_value += int (address_str)
        nozzle_address = str(nozzle_value)
        return nozzle_address

    def get_default_printer_head_config(self):
        return self.HEAD_CONFIG_DEFAULT

    def get_number_of_Nozzles(self):
        return self.printer_head.get_number_of_Nozzles()

    def calculate_band_config_for_test (self, selected_nozzles):
        number_of_bands = len (selected_nozzles)
        self.create_band_config(number_of_bands=number_of_bands )
        bands = self.band_config.get_bands()
        for idx, Band in enumerate(bands):
            Band.set_nozzle_id(selected_nozzles[idx])

    def nozzle_testing_process(self, selected_nozzles):
        self.calculate_band_config_for_test(selected_nozzles)
        gcode = self.generate_gcode()
        print (gcode)
        self.generate_gcode_and_send()

    def generate_gcode(self):
        gcode_start = GCODES.SET_REFERENCE
        gcode_for_bands = self.band_config.to_gcode()
        gcode_end = GCODES.END
        return (gcode_start + "\n" + gcode_for_bands + "\n" + gcode_end)

    def get_default_plate_config(self):
        return self.PLATE_CONFIG_DEFAULT
