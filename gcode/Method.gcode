M42 P40 S255; close contact
G4 P250; wait security
M42 P40 S0; open contact
G90
G28 X
G1 X104.2 F2500
G92 Y150 Z150
G1 Y0 Z0
G28 Y Z
G1 Y8.3 Z8.3 F2000
G4 P500; waiting security
M42 P59 S255
G4 P2000
M42 P59 S0
G4 P2000
M42 P42 S255; plate gas on
G1 Z0.25 Y0.25;compensate Y backslash
G1 Z63.44 Y63.44
G1 X175.05
M400
G4 P1000
M42 P64 S255; head down
G4 P1000; waiting security
M42 P66 S255; activate rheodyn
G4 P2000; insert numeric elution time
M42 P66 S0; deactivate rheodyn
G4 P1000; waiting security
M42 P64 S0; head up
G4 P1000; waiting security
M42 P65 S255; drawer out
G4 P500; waiting security
M42 P44 S255; head cleaning on
G4 P1000; waiting security
M42 P44 S0; head cleaning off
G4 P500; waiting security
M42 P44 S255; head cleaning on
G4 P1000; waiting security
M42 P44 S0; head cleaning off
G4 P500; waiting security
M42 P65 S0; drawer in
G4 P2000; insert numeric rinsing time
M42 P59 S255
G4 P2000
M42 P59 S0
G4 P2000
G1 X104.2 Y148.3 Z148.3
M42 P42 S0; plate gas off
M84
