# eat_table_Scan_dart = 
function(step){
  # eat_table_Scan_dart function V011,07 March 2017
  # very simple anyway, home, start heating, and wait the needed time, then home again
  # extract the needed information
  table = step$table
  nbr_band=table[table[,1] == "nbr_band",2];
  speed_travel=table[table[,1] == "speed_travel",2]
  speed_scan=table[table[,1] == "speed_scan",2]
  gap=table[table[,1] == "gap",2]
  dist_gauche=table[table[,1] == "dist_gauche",2]
  Y_start=table[table[,1] == "Y_start",2]
  Y_end=table[table[,1] == "Y_end",2]
  M42=table[table[,1] == "M42",2]
  
  gcode = c( ## begin Gcode
    "M106 S255; fan on, for the 12v of the end stops",
    "G28 X0; home X axis",
    "G28 Y0; home X axis",
    "G21 ; set units to millimeters",
    "G90 ; use absolute coordinates"
  )
  for(i in 0:(nbr_band-1)){
    gcode = c(gcode, ## fill gcode
              paste0("G1 F",60*speed_travel," ; set speed in mm per min for the travel movement"),
              "G1 X0; go in X0",
              "G1 Y0; go in Y0",
              paste0("G1 X",dist_gauche + i*gap," ; go in X band position"),
              paste0("G1 Y",Y_start," ; go in Y start"),
              if(as.logical(M42)){c("M42 P63 S1;set pin 63 to high","G4 P20;wait 20 ms","M42 P63 S0;set pin 63 to low")},
              paste0("G1 F",60*speed_scan," ; set speed in mm per min for the scan movement"),
              paste0("G1 Y",Y_end," ; go in Y end")
    )
  }
  gcode = c(gcode, ## end gcode
            "G28 X0; go in X0",
            "G28 Y0; go in Y0",
            "M84     ; disable motors"
  )
  
  plot_step=function() {
    plot(x=0,y=0,type="n",xlim=c(0,100),ylim=c(0,100),xlab="X",ylab="Y",sub = "Careful of X, Y and direction for first scans")
    ## add stuff on the plate
    for(i in 0:(nbr_band-1)){
      segments(x0=dist_gauche + i*gap,
               y0=Y_start,y1=Y_end)
    }
  }
  
  # replace the parts
  if(!is.null(step$appli_table)){step$appli_table = NULL} ## bug, bug, bug
  step$gcode = gcode
  step$plot = plot_step
  step$info = "Calcul from the middle of the band (ATS4 convention)\nBe carefull with X and Y inversion"
  return(step)
}