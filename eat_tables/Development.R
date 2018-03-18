function(step){
  # extract the needed information
  table = step$table
  path = table[table[,1] == "path",2]
  speed = table[table[,1] == "speed",2]
  I = table[table[,1] == "I",2]
  L = table[table[,1] == "L",2]
  wait = table[table[,1] == "wait",2]
  wait_inc = table[table[,1] == "wait_inc",2]
  return = table[table[,1] == "return",2]
  plate_x = table[table[,1] == "plate_x",2]
  plate_y = table[table[,1] == "plate_y",2]
  dev_dir = table[table[,1] == "dev_dir",2]
  dev_length = table[table[,1] == "dev_length",2]
  dist_bottom = table[table[,1] == "dist_bottom",2]
  dist_gauche = 50 - dev_length/2 ## this one is infered
  
  ## deal with dev_dir and plate dimension
  if(dev_dir == 0 && plate_x == 50){
    dist_bottom = dist_bottom +25
  }
  if(dev_dir == 0 && plate_y == 50){
    # dist_gauche = dist_gauche +25
  }
  if(dev_dir == 1 && plate_y == 50){
    dist_bottom = dist_bottom +25
  }
  if(dev_dir == 1 && plate_x == 50){
    # dist_gauche = dist_gauche +25
  }
  
  
  ## Start dimension
  inche = 25.4 # mm/inche
  dpi = 96
  reso = round(inche/dpi,3)
  S = 4095 ## may be integrate it for later in the table
  
  wait_vec = c()
  for(i in seq(path)){
    wait_vec = c(wait_vec,round(wait,3))
    wait = wait*wait_inc
  }
  timing = ((dev_length)/speed*2+(dev_length)/reso*I*0.9/1000)
  
  start_gcode = c("G28 X0; home X axis",
                  "G28 Y0; home Y axis",
                  "G21 ; set units to millimeters",
                  "G90 ; use absolute coordinates",
                  paste0("G1 F",60*speed," ; set speed in mm per min for the movement"),
                  paste0(if(dev_dir == 0){paste0("G1 X",dist_bottom)}else{paste0("G1 Y",dist_bottom-reso*6.5)}," ; go in position")
  )
  end_gcode = c("G28 X0; home X axis",
                "G28 Y0; home Y axis",
                "M84     ; disable motors")
  
  ## begin gcode
  gcode = c(start_gcode,unlist(lapply(seq(path),function(k){
    gcode = c()
    coord = round(seq(from = dist_gauche,by=reso,length.out = ceiling(dev_length/reso)),3)
    for(i in coord){
      gcode = c(gcode,
                paste0(if(dev_dir == 0){"G1 Y"}else{"G1 X"},i," ; go in position"),
                "M400 ; Wait for current moves to finish ",
                paste0("M700 P0 I",I," L",L," S",S," ; Fire inkjet bits")
      )
    }
    if(wait != 0){gcode=c(gcode,paste0("G4 S",wait_vec[k],"; wait in seconds"))}
    if(return != 0){
      coord = rev(coord)
      for(i in coord){
        gcode = c(gcode,
                  paste0(if(dev_dir == 0){"G1 Y"}else{"G1 X"},i," ; go in position"),
                  "M400 ; Wait for current moves to finish ",
                  paste0("M700 P0 I",I," L",L," S",S," ; Fire inkjet bits")
        )
      }
      if(wait != 0){gcode=c(gcode,paste0("G4 S",wait_vec[k],"; wait in seconds"))}
    }
    gcode
  })))
  gcode = c(gcode,end_gcode)
  
  ## plot
  plot_step=function() {
    plot(c(1,100),c(1,100),ylim=c(100,0),xlim=c(0,100),type="n",xlab="X",ylab="Y",main="Origin in upper left corner")
    # segments(x0=X_left,x1=X_right,y0=Y)
    symbols(x=50,y=50,add = T,inches = F,rectangles = rbind(c(plate_x,plate_y)),lty=2)
    if(dev_dir == 1){
      symbols(y=dist_bottom,x=50,rectangles = rbind(c(dev_length,3)),add = T,inches = F,bg = 1)
    }else if(dev_dir == 0){
      symbols(x=dist_bottom,y=50,rectangles = rbind(c(0.25,dev_length)),add = T,inches = F,bg = 1)
    }
  }
  
  timing = timing*path + sum(wait_vec)
  volume = round(I*12*0.1/1000*(dev_length)/reso*path,3)
  if(return != 0){
    timing = timing *2
    volume = volume*2
  }
  # replace the parts
  # if(!is.null(step$appli_table)){step$appli_table = NULL} ## bug, bug, bug
  step$gcode = gcode
  step$plot = plot_step
  step$info = c("Plate length and width must be 50 mm or 100 mm, nothing else\n",
                "There is no security for bad values, be careful\n",
                paste0("Volume used (µL): ",volume,"\n"),
                paste0("Estimated time: ",round(timing), " [s] = ",round(timing/60,2)," [min]"))
  return(step)
}