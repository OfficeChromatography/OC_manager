def new_lines(arr):
    return "\n".join(arr)

GO = "G1"

GO_X = GO + "X"
GO_X_MINUS = GO_X + "-"

GO_Y = GO + "Y"
GO_Y_MINUS = GO_Y + "-"

SET_REFERENCE = "G91"

SET_ABSOLUTE_POS = "G90"

DISABLE_STEPPER_MOTORS = "M18"

GO_TO_ORIGIN = "G28"

GO_TO_ORIGIN_X = "G28 X0"

GO_TO_ORIGIN_Y = "G28 Y0"

SET_UNITS_IN_MM = "G21"

STOP_IDLE_HOLD = "M84"

WAIT_UNTIL_FIRE = "M400"

FIRE = "M700"

END = new_lines([GO_TO_ORIGIN_X, GO_TO_ORIGIN_Y, STOP_IDLE_HOLD ])

def nozzle_fire(fire_rate, nozzle_address, puls_delay):
    return new_lines([
        FIRE,
        "P0", # board 0
        "I" + fire_rate,
        "L" + puls_delay,
        "S" + nozzle_address])

def goXMinus(steps = "5"):
    return GO_X_MINUS + steps

def goXPlus(steps = "5"):
    return GO_X + steps

def goYMinus(steps = "5"):
    return GO_Y_MINUS + steps

def goYPlus(steps = "5"):
    return GO_Y + steps

def go_speed(speed):
    return GO+" F "+speed

def start(speed, distX):
    return new_lines([
        GO_TO_ORIGIN,
        GO_TO_ORIGIN_Y,
        SET_UNITS_IN_MM,
        SET_ABSOLUTE_POS,
        go_speed(speed),
        GO_X + distX]) # maybe needs a refactor



