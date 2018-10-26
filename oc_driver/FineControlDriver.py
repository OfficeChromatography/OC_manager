import gcodes as GCODES 

class FineControlDriver:

    def __init__(self, communication):
        self.communication = communication
 
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

    def stop(self):
        return self.communication.send([GCODES.DISABLE_STEPPER_MOTORS])

    def fire_selected_nozzles(self, fire_rate, puls_delay, selected_nozzles):
        nozzle_value = 0
        if type(selected_nozzles) == list:
            for nozzle in selected_nozzles:
                nozzle_value += 2 ** (nozzle-1)
        else:
            nozzle_value = 2 ** (selected_nozzles -1) 
        nozzle_address= str(int(nozzle_value))
        print (nozzle_address)
        self.communication.send([
            GCODES.nozzle_fire(fire_rate, nozzle_address, puls_delay)
        ])
