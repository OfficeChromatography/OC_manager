
from math import pi as pi

class Nozzle:
    " represents a printer head's nozzle "
    
    def __init__(self, nozzle_id, address):
        self.nozzle_id = nozzle_id
        self.address = address

    def get_shift(self, printer_head_resolution):
        "calculates the nozzle's shift (relative offset to next nozzle), returns float"
        return float(round(( ( 12 - self.nozzle_id ) * printer_head_resolution), 3))

    def get_address(self):
        "get binary address of nozzle as a string"
        return self.address
        
class PrinterHead:

    "represents a configuration for a oc - printer head, contains its nozzle configuration"


    # setup the nozzle channels as wanted. Checkout the binary signal documentation for your print head
    NOZZLE_CHANNEL = {
        1 : "3",
        2 : "4",
        3 : "5",
        4 : "2",
        5 : "1",
        6 : "12",
        7 : "11"
    }

            
    def __init__(self, head_config):

        
        """ head_config: dict {
        'speed': number,            
        'number_of_fire': number,     
        'pulse_delay': number,      
        'printer_head_resolution: float '
        'step_range'
        } """
        self.speed = float(head_config.get('speed'))
        self.number_of_fire = float(head_config.get('number_of_fire'))
        self.pulse_delay = float(head_config.get('pulse_delay'))
        self.step_range = float(head_config.get('step_range'))
        self.printer_head_resolution = float(head_config.get('printer_head_resolution'))
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
        "calculate nozzle address and returns a string"
        address = self.nozzles.get(nozzle_id).get_address()
        address_as_binary_string = str ( 2 ** (int (address) -1 ) )
        return address_as_binary_string

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
        return self.number_of_fire

    def get_number_of_Nozzles(self):
        "how many nozzle are used from the printer head"
        return (len (self.NOZZLE_CHANNEL))

    def calculate_speed_in_mms(self, speed_in_RPM):
        "calcualtes the speed in mm/s"
        speed_in_mms = round(speed_in_RPM/60,3)
        return speed_in_mms

    def calculate_nozzle_fire_waiting_time (self, fire_rate):
        max_delay = 800 * 10**(-6)
        return fire_rate * max_delay

    
