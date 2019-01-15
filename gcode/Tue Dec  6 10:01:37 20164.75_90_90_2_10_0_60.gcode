G28 ; home all axis, will have a problem with the Z
G29 ; perform bed levelling
G21 ; set units to millimeters
G90 ; use absolute coordinates
M82 ; use absolute distances for extrusion
G92 E0
G1 F3600 ; set speed in mm per min for the movement
G1 Z0 ; go in Z offset position
G1 X4.75 Y2 ; go in first position
G1 X4.75 Y92 E0.045 ; print
G1 X94.75 Y92 E0.09 ; print
G1 X94.75 Y2 E0.135 ; print
G92 E0
G1 Z5; move Z 5 mm upper
G1 E-10.135; move the piston pusher up
M84     ; disable motors
