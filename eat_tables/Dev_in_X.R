# eat_table_Dev_in_X = 
function(step){
  ## eat_table_Dev_in_X function V01,26 april 2017
  # in each position, we fire every body, no need for nozzles
  ## extract the needed information
  table = step$table
  
  inche = 25.4 # mm/inche
  dpi = 96
  reso = round(inche/dpi,3)
  
  ## empty array
  path = table[table[,1] == "path",2]
  Y = table[table[,1] == "Y",2] + 25
  X_left = table[table[,1] == "X_left",2] 
  X_right = table[table[,1] == "X_right",2] 
  speed = table[table[,1] == "speed",2]
  I = table[table[,1] == "I",2]
  L = table[table[,1] == "L",2]
  wait = table[table[,1] == "wait",2]
  wait_inc = table[table[,1] == "wait_inc",2]
  return = table[table[,1] == "return",2]
  
  S = 4095 ## may be integrate it for later in the table
  
  wait_vec = c()
  for(i in seq(path)){
    wait_vec = c(wait_vec,round(wait,3))
    wait = wait*wait_inc
  }
  timing = ((X_right-X_left)/speed*2+(X_right-X_left)/reso*I*0.9/1000)
  
  start_gcode = c("G28 X0; home X axis",
                  "G28 Y0; home Y axis",
                  "G21 ; set units to millimeters",
                  "G90 ; use absolute coordinates",
                  paste0("G1 F",60*speed," ; set speed in mm per min for the movement"),
                  paste0("G1 Y",Y-reso*6.5," ; go in Y position")
  )
  end_gcode = c("G28 X0; home X axis",
                "G28 Y0; home Y axis",
                "M84     ; disable motors")
  
  ## begin gcode
  gcode = c(start_gcode,unlist(lapply(seq(path),function(k){
    gcode = c()
    X = X_left
    for(i in seq((X_right-X_left)/reso)){
      gcode = c(gcode,
                paste0("G1 X",X," ; go in X position"),
                "M400 ; Wait for current moves to finish ",
                paste0("M700 P0 I",I," L",L," S",S," ; Fire inkjet bits")
      )
      X = X + reso
    }
    if(wait != 0){gcode=c(gcode,paste0("G4 S",wait_vec[k],"; wait in seconds"))}
    if(return != 0){
      X = X_right
      for(i in seq((X_right-X_left)/reso)){
        gcode = c(gcode,
                  paste0("G1 X",X," ; go in X position"),
                  "M400 ; Wait for current moves to finish ",
                  paste0("M700 P0 I",I," L",L," S",S," ; Fire inkjet bits")
        )
        X = X - reso
      }
      if(wait != 0){gcode=c(gcode,paste0("G4 S",wait_vec[k],"; wait in seconds"))}
    }
    gcode
  })))
  gcode = c(gcode,end_gcode)
  
  ## plot, need recall of Y positions
  X_left = table[table[,1] == "X_left",2]
  X_right = table[table[,1] == "X_right",2]
  # Y = table[table[,1] == "Y",2]
  wait = table[table[,1] == "wait",2]
  plot_step=function() {
    par(mfrow=c(1,2))
    plot(c(1,100),c(1,100),ylim=c(100,0),xlim=c(0,100),type="n",xlab="X",ylab="Y",main="Origin in upper left corner")
    segments(x0=X_left,x1=X_right,y0=Y)
    plot(wait_vec,ylim= c(0,max(wait_vec)),main="Dwell time evolution",ylab="dwell time (sec)",xlab="path")
    abline(h=c(25,75),lty=2)
  }
  
  timing = timing*path + sum(wait_vec)
  volume = round(I*12*0.1/1000*(X_right-X_left)/reso*path,3)
  if(return != 0){
    timing = timing *2
    volume = volume*2
  }
  # replace the parts
  step$gcode = gcode
  step$plot = plot_step
  step$info = c("for plate of 50*100 mm.\n","application on the left side\n","Same as SA_2\n",
                paste0("Volume used (µL): ",volume,"\n"),
                paste0("Estimated time: ",round(timing), " sec = ",round(timing/60,2)," min"))
  return(step)
}