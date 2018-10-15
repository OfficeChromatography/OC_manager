
GO  = "G1"

GO_X = GO + "X"
GO_X_MINUS = GO_X + "-"

GO_Y = GO + "Y"
GO_Y_MINUS = GO_Y + "-"

SET_REFERENCE = "G91"

SET_ABSOLUTE_POS = "G90"

DISABLE_STEPPER_MOTORS = "M18"

GO_TO_ORIGIN = "G28"

def goXMinus(steps = "5"):
    return GO_X_MINUS + steps

def goXPlus(steps = "5"):
    return GO_X + steps

def goYMinus(steps = "5"):
    return GO_Y_MINUS + steps

def goYPlus(steps = "5"):
    return GO_Y + steps


