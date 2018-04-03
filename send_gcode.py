# send_gcode
gcode=[i.strip() for i in open("gcode/LED.gcode")] # or pass in your own array of gcode lines instead of reading from a file
gcode = gcoder.LightGCode(gcode)
p.startprint(gcode)
