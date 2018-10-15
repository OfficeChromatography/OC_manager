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

    def goHome(self):
        self.communication.send([
            GCODES.GO_TO_ORIGIN,
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
