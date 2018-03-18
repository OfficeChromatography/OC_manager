function(step){
  # extract the needed information
  table = step$table;
  band_length = table[table[,1] == "band_length",2]
  dist_gauche = table[table[,1] == "dist_gauche",2];dist_gauche = dist_gauche-band_length/2
  gap = table[table[,1] == "gap",2];gap=gap-band_length
  speed = table[table[,1] == "speed",2]
  dist_bottom = table[table[,1] == "dist_bottom",2]
  path=table[table[,1] == "path",2];
  L=table[table[,1] == "L",2];
  W=table[table[,1] == "wait",2];
  nbr_band = table[table[,1] == "nbr_band",2]
  nozzle = table[table[,1] == "nozzle",2]
  dev_dir = table[table[,1] == "dev_dir",2] ## 0 for X, 1 for Y
  plate_x = table[table[,1] == "plate_x",2]
  plate_y = table[table[,1] == "plate_y",2]
  
  ## deal with dev_dir and plate dimension
  if(dev_dir == 0 && plate_x == 50){
    dist_bottom = dist_bottom +25
  }
  if(dev_dir == 0 && plate_y == 50){
    dist_gauche = dist_gauche +25
  }
  if(dev_dir == 1 && plate_y == 50){
    dist_bottom = dist_bottom +25
  }
  if(dev_dir == 1 && plate_x == 50){
    dist_gauche = dist_gauche +25
  }
  
  
  ## deal with evolution in nbr of band
  if(is.null(step$appli_table)){## create original table
    step$appli_table = data.frame(Repeat = rep(1,nbr_band),I = rep(10,nbr_band),Use = rep(T,nbr_band))
  }else if(nrow(step$appli_table) < nbr_band){## modify table length
    step$appli_table = rbind(
      step$appli_table,
      data.frame(Repeat = rep(1,nbr_band),I = rep(10,nbr_band),Use = rep(T,nbr_band))
    )[seq(nbr_band),]
  }else if(nrow(step$appli_table) > (nbr_band)){## modify table length
    step$appli_table = step$appli_table[seq(nbr_band),]
  }
  rownames(step$appli_table) = seq(nrow(step$appli_table))
  SA_table = step$appli_table
  
  
  
  ## empty array
  inche = 25.4 # mm/inche
  dpi = 96
  reso = inche/dpi
  S = rep(0,12)
  for(i in seq(12)){if(i %in% as.numeric(nozzle)){S[i] = 1}};S = BinToDec(S)
  shift = round((1 - nozzle)*reso,3)
  if(dev_dir == 1){dist_bottom = dist_bottom + shift}
  
  # nozzle_Y = 1 ## use only one nozzle
  # plate_Y=100
  
  start_gcode = c("G28 X0; home X axis",
                  "G28 Y0; home Y axis",
                  "G21 ; set units to millimeters",
                  "G90 ; use absolute coordinates",
                  paste0("G1 F",60*speed," ; set speed in mm per min for the movement"),
                  paste0(if(dev_dir == 0){"G1 X"}else{"G1 Y"},dist_bottom," ; go in X position") 
  )
  end_gcode = c("G28 X0; home X axis",
                "G28 Y0; home Y axis",
                "M84     ; disable motors")
  ## previously function a_to_gcode_X_fix
  
  
  
  ## begin gcode
  ## iterate
  gcode = c(start_gcode,unlist(lapply(seq(path),function(k){
    gcode = c()
    for(band in seq(nrow(SA_table))){
      Y_coord = round(seq(from = dist_gauche+(band-1)*(gap+band_length),by=reso,length.out = ceiling(band_length/reso)),3)
      if(dev_dir == 0){Y_coord = Y_coord + shift}
      if(SA_table$Use[band]){
        I = SA_table$I[band]
        for(Repeat in seq(SA_table$Repeat[band])){
          for(i in Y_coord){ # X loop, need modulo
            gcode = c(gcode,paste0(if(dev_dir == 0){"G1 Y"}else{"G1 X"},i," ; go in position - path: ",k))
            gcode = c(gcode,"M400 ; Wait for current moves to finish ")
            gcode = c(gcode,paste0("M700 P0 I",I," L",L," S",S," ; Fire"))
          }
        }
      }
    }
    if(W != 0){gcode=c(gcode,paste0("G4 S",W,"; wait in seconds"))}
    gcode
  })))
  gcode = c(gcode,end_gcode)
  
  plot_step=function() {
    plot(c(1,100),c(1,100),type="n",xlim=c(0,100),ylim=c(100,0),xlab="X",ylab="Y",main="Origin in upper left corner")
    for(band in seq(nrow(SA_table))){
      if(SA_table$Use[band]){
        if(dev_dir == 0){
          segments(x0 = dist_bottom,
                   y0 = dist_gauche+shift+(band-1)*(gap+band_length),
                   y1 = dist_gauche+shift+(band-1)*(gap+band_length)+band_length)
        }else if(dev_dir == 1){
          segments(y0 = dist_bottom,
                   x0 = dist_gauche+shift+(band-1)*(gap+band_length),
                   x1 = dist_gauche+shift+(band-1)*(gap+band_length)+band_length)
        }
      }
    }
    symbols(x=50,y=50,add = T,inches = F,rectangles = rbind(c(plate_x,plate_y)),lty=2)
  }
  ## security
  # plate dim
  # too much bands ???
  # L too big
  # band > gap
  
  ## replace the parts
  step$gcode = gcode
  step$plot = plot_step
  step$info = c("Plate length and width must be 50 mm or 100 mm, nothing else\n",
                "There is no security for bad values, be careful\n",
                paste0("Band ",seq(nrow(SA_table)),": ", SA_table$I*Drop_vol*ceiling(band_length/reso)*SA_table$Repeat*path/1000," µL used\n")
  )
  return(step)
}