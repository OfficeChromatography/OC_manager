
import gcodes as GCODES
from SampleApplicationDriver import SampleApplicationDriver

class FineControlDriver:

    def __init__(self, communication):
        self.communication = communication
        self.ApplicationDriver = SampleApplicationDriver(self.communication)
 
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
        self.ApplicationDriver._set_configs(head_config=printer_head_config)

    def stop(self):
        return self.communication.send([GCODES.DISABLE_STEPPER_MOTORS])

    def fire_selected_nozzles(self, selected_nozzles):
        printer_head = self.ApplicationDriver.printer_head        
        nozzle_address = self.calculate_nozzle_adress_for_gcode(selected_nozzles, printer_head)
        fire_rate = printer_head.get_number_of_fire()
        puls_delay = printer_head.get_pulse_delay()
        print (GCODES.nozzle_fire(fire_rate, nozzle_address, puls_delay))
        self.communication.send([
            GCODES.nozzle_fire(fire_rate, nozzle_address, puls_delay)
        ])

    def calculate_nozzle_adress_for_gcode(self, selected_nozzles, printer_head):
        nozzle_value = 0
        if type(selected_nozzles) == list:
            for nozzle in selected_nozzles:
                address_int  = printer_head.get_address_for_nozzle(nozzle)
                nozzle_value += int (address_int)
            nozzle_address= str(int(nozzle_value))
        else:
            nozzle_address = printer_head.get_address_for_nozzle(selected_nozzles)
        print (nozzle_address)
        return nozzle_address

    def get_default_printer_head_config(self):
        return self.ApplicationDriver.get_default_printer_head_config()

    def get_number_of_Nozzles(self):
        return self.ApplicationDriver.printer_head.get_number_of_Nozzles()    
