M106 S255; fan on, for the 12v of the end stops
G28 X0; home X axis
G28 Y0; home X axis
G21 ; set units to millimeters
G90 ; use absolute coordinates
G1 F300 ; set speed in mm per min for the travel movement
G1 X0; go in X0
G1 Y0; go in Y0
G1 X10 ; go in X band position
G1 Y20 ; go in Y start
G1 F12 ; set speed in mm per min for the scan movement
G1 Y80 ; go in Y end
G1 F300 ; set speed in mm per min for the travel movement
G1 X0; go in X0
G1 Y0; go in Y0
G1 X30 ; go in X band position
G1 Y20 ; go in Y start
G1 F12 ; set speed in mm per min for the scan movement
G1 Y80 ; go in Y end
G1 F300 ; set speed in mm per min for the travel movement
G1 X0; go in X0
G1 Y0; go in Y0
G1 X50 ; go in X band position
G1 Y20 ; go in Y start
G1 F12 ; set speed in mm per min for the scan movement
G1 Y80 ; go in Y end
G1 F300 ; set speed in mm per min for the travel movement
G1 X0; go in X0
G1 Y0; go in Y0
G1 X70 ; go in X band position
G1 Y20 ; go in Y start
G1 F12 ; set speed in mm per min for the scan movement
G1 Y80 ; go in Y end
G1 F300 ; set speed in mm per min for the travel movement
G1 X0; go in X0
G1 Y0; go in Y0
G1 X90 ; go in X band position
G1 Y20 ; go in Y start
G1 F12 ; set speed in mm per min for the scan movement
G1 Y80 ; go in Y end
M84     ; disable motors
