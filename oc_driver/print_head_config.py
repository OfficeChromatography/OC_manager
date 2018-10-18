class Nozzle:
    " represents a printer head's nozzle "
    
    def __init__(self, nozzle_id, address):
        self.nozzle_id = nozzle_id
        self.address = address

    def get_shift(self, printer_head_resolution):
        "calculates the nozzle's shift (relative offset to next nozzle), returns float"
        return float(round((1- self.nozzle_id * printer_head_resolution), 3))

    def get_address(self):
        "get binary address of nozzle as a string"
        return self.address
        
class PrinterHead:

    "represents a configuration for a oc - printer head, contains its nozzle configuration"


    # setup the nozzle channels as wanted. Checkout the binary signal documentation for your print head
    NOZZLE_CHANNEL = {
        1 : format(1, '016b'),
        2 : format(2, '016b'),
        3 : format(4, '016b'),
        4 : format(8, '016b'),
        5 : format(16, '016b'),
        6 : format(32, '016b'),
        7 : format(64, '016b'),
    }

            
    def __init__(self, head_config):

        
        """ head_config: dict {
        'speed': number,            
        'number_of_fire': number,     
        'pulse_delay': number,      
        'printer_head_resolution: float '
        'step_range'
        } """
        self.speed = head_config.get('speed')
        self.number_of_fire = head_config.get('number_of_fire')
        self.pulse_delay = head_config.get('pulse_delay')
        self.step_range = head_config.get('step_range')
        self.printer_head_resolution = head_config.get('printer_head_resolution')
        self.init_with_default_settings()

    def get_pulse_delay(self):
        "defines the signal used by liquid application. E. g. defining the drop size, etc."
        return self.pulse_delay

    def init_with_default_settings(self):
        "sets nozzles internally using the NOZZLE_CHANNEL config (see above)"
        nozzles = {}
        for nozzle_id, address in self.NOZZLE_CHANNEL.items():
            nozzles[nozzle_id] = Nozzle(nozzle_id, address)
        self.nozzles = nozzles


                
    def get_shift_for_nozzle(self, nozzle_id):
        "defines a relative offset for each nozzle specified by the printer head geometry"
        return self.nozzles.get(nozzle_id) \
                           .get_shift(self.printer_head_resolution)


    def get_address_for_nozzle(self, nozzle_id):
        return self.nozzles.get(nozzle_id).get_address()

    def get_resolution(self):
        "absolute distance from each nozzle to another" 
        return self.printer_head_resolution

    def get_speed(self):
        "speed of the printer head: mm/minute"
        return self.speed

    def get_step_range(self):
        "distance of the printer head's movement between each printing action"
        return self.step_range

    def get_number_of_fire(self):
        "number of printing actions on each print position"
        return self.get_number_of_fire
