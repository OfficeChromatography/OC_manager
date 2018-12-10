def new_lines(arr):
    return "\n".join(arr)

GO = "G1"

GO_X = GO + " X"
GO_X_MINUS = GO_X + "-"

GO_Y = GO + " Y"
GO_Y_MINUS = GO_Y + "-"

SET_REFERENCE = "G91"

SET_ABSOLUTE_POS = "G90"

DISABLE_STEPPER_MOTORS = "M18"

GO_TO_ORIGIN = "G28"

GO_TO_ORIGIN_X = "G28 X0"

GO_TO_ORIGIN_Y = "G28 Y0"

SET_UNITS_IN_MM = "G21"

STOP_IDLE_HOLD = "M84"

CURR_MOVEMENT_FIN = "M400"

FIRE = "M700"

GET_POSITION = "M114"

LED_OFF = "M150 W0 R0 U0 B0"

GO_TO_FOTO_POSITION = "G1 Y158"

END = new_lines([GO_TO_ORIGIN_X, GO_TO_ORIGIN_Y, STOP_IDLE_HOLD ])


def nozzle_fire(fire_rate, nozzle_address, puls_delay):
    return  CURR_MOVEMENT_FIN + "\n" + \
        FIRE  + " P0 " + "I" + str(fire_rate) + " L" + str(puls_delay) + " S" + nozzle_address + "\n" +\
        CURR_MOVEMENT_FIN

def goXMinus(steps = "5"):
    return GO_X_MINUS + str(steps)

def goXPlus(steps = "5"):
    return GO_X + str(steps)

def goYMinus(steps = "5"):
    return GO_Y_MINUS + str(steps)

def goYPlus(steps = "5"):
    return GO_Y + str(steps)

def go_speed(speed):
    return " F "+str(speed)

def start(speed, distX):
    return new_lines([
        GO_TO_ORIGIN_X,
        GO_TO_ORIGIN_Y,
        SET_UNITS_IN_MM,
        SET_ABSOLUTE_POS,
        goXPlus(distX) + go_speed(speed)]) # maybe needs a refactor, go(direction, axis)

def LEDs(white, red, green, blue):
    return "M150" + " W" + str(white) + " R" + str( red ) + " U" + str (green) + " B" + str (blue) 

