eat_table_SA_prep = function(step){
  ## eat_table_Dev_2 function V01,19 april 2017
  # in each position, we fire every body, no need for nozzles
  ## extract the needed information
  table = step$table
  
  inche = 25.4 # mm/inche
  dpi = 96
  reso = round(inche/dpi,3)
  
  ## empty array
  path = table[table[,1] == "path",2]
  dist_bottom = table[table[,1] == "dist_bottom",2]
  dist_gauche = table[table[,1] == "dist_gauche",2]
  band_length = table[table[,1] == "band_length",2] 
  speed = table[table[,1] == "speed",2]
  I = table[table[,1] == "I",2]
  L = table[table[,1] == "L",2]
  wait = table[table[,1] == "wait",2]
  S = table[table[,1] == "S",2]
  

  timing = (band_length/speed*2+band_length/reso*I*0.9/1000)
  
  start_gcode = c("G28 X0; home X axis",
                  "G28 Y0; home Y axis",
                  "G21 ; set units to millimeters",
                  "G90 ; use absolute coordinates",
                  paste0("G1 F",60*speed," ; set speed in mm per min for the movement"),
                  paste0("G1 X",dist_bottom," ; go in X position")
  )
  end_gcode = c("G28 X0; home X axis",
                "G28 Y0; home Y axis",
                "M84     ; disable motors")
  
  ## begin gcode
  gcode = c(start_gcode,unlist(lapply(seq(path),function(k){
    gcode = c()
    Y = dist_gauche
    for(i in seq(band_length/reso)){
      gcode = c(gcode,
                paste0("G1 Y",Y," ; go in first Y position"),
                "M400 ; Wait for current moves to finish ",
                paste0("M700 P0 I",I," L",L," S",S," ; Fire inkjet bits")
      )
      Y = Y +reso
    }
    if(wait != 0){gcode=c(gcode,paste0("G4 S",wait,"; wait in seconds"))}
    gcode
  })))
  gcode = c(gcode,end_gcode)
  
  ## plot, need recall of Y positions
  # Y_left = table[table[,1] == "Y_left",2]
  # Y_right = table[table[,1] == "Y_right",2]
  plot_step=function() {
    plot(c(1,100),c(1,100),ylim=c(100,0),xlim=c(0,100),type="n",xlab="X",ylab="Y",main="Origin in upper left corner")
    segments(x0=dist_bottom,y0=dist_gauche,y1=dist_gauche+band_length)
  }
  
  timing = timing*path + wait*path
  # replace the parts
  step$gcode = gcode
  step$plot = plot_step
  step$info = c("for plate of 100*100 mm.\n","application on the left side\n",
                  paste0(sum(as.numeric(intToBits(S)))," nozzles used\n"),
                paste0("Volume used (µL): ",round(I*sum(as.numeric(intToBits(S)))*Drop_vol/1000*band_length/reso*path,3),"\n"),
                paste0("Estimated time: ",round(timing), " sec = ",round(timing/60,2)," min"))
  return(step)
}

