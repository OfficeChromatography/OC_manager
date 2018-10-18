from oc_driver import gcodes as GCODES 

class FineControlDriver:

    def __init__(self, communication):
        self.compFinemunication = communication

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
