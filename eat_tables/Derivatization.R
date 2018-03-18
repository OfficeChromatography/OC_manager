function(step){
  # extract the needed information
  table = step$table
  dist_gauche = table[table[,1] == "dist_gauche",2]
  band_length = table[table[,1] == "band_length",2]
  gap = table[table[,1] == "gap",2]##;gap=gap-band_length## no need for linomat conversion here
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
  deriv_length = table[table[,1] == "deriv_length",2]
  
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
  deriv_table = step$appli_table
  
  ## Start dimension
  inche = 25.4 # mm/inche
  dpi = 96
  reso = inche/dpi
  if(nozzle != 0){
    S = rep(0,12)
    for(i in seq(12)){if(i %in% as.numeric(nozzle)){S[i] = 1}};S = BinToDec(S)
    shift = round((1 - nozzle)*reso,3)
  }else{
    S = 4095;shift=0
  }
  if(dev_dir == 1){dist_bottom = dist_bottom + shift}else{dist_gauche = dist_gauche +shift}
  
  
  start_gcode = c("G28 X0; home X axis",
                  "G28 Y0; home Y axis",
                  "G21 ; set units to millimeters",
                  "G90 ; use absolute coordinates",
                  paste0("G1 F",speed," ; set speed in mm per min for the movement")
  )
  end_gcode = c("G28 X0; home X axis",
                "G28 Y0; home Y axis",
                "M84     ; disable motors")
  
  ## begin gcode
  ## iterate
  gcode = c(start_gcode,unlist(lapply(seq(path),function(k){
    gcode = c()
    for(band in seq(nrow(deriv_table))){
      gcode = c(gcode,
                paste0(if(dev_dir == 0){"G1 Y"}else{"G1 X"},dist_gauche+(band-1)*gap,"; go in band position"))
      if(deriv_table$Use[band]){
        I = deriv_table$I[band]
        for(Repeat in seq(deriv_table$Repeat[band])){
          coord = round(seq(from = dist_bottom,by=reso,length.out = ceiling(deriv_length/reso)),3)
          for(i in coord){
            gcode = c(gcode,paste0(if(dev_dir == 0){"G1 X"}else{"G1 Y"},i," ; go in position"))
            gcode = c(gcode,"M400 ; Wait for current moves to finish ")
            gcode = c(gcode,paste0("M700 P0 I",I," L",L," S",S," ; Fire inkjet bits"))
          }
        }
      }
    }
    gcode
  })))
  
  gcode = c(gcode,end_gcode)
  
  plot_step=function() {
    plot(c(1,100),c(1,100),type="n",xlim=c(0,100),ylim=c(100,0),xlab="X",ylab="Y",main="Origin in upper left corner")
    for(band in seq(nrow(deriv_table))){
      if(deriv_table$Use[band]){
        if(dev_dir == 0){
          symbols(x=dist_bottom+deriv_length/2,y=dist_gauche+(band-1)*gap,rectangles = rbind(c(deriv_length,if(nozzle == 0){3}else{0.25})),add = T,inches = F,bg = 1)
        }else if(dev_dir == 1){
          symbols(y=dist_bottom+deriv_length/2,x=dist_gauche+(band-1)*gap,rectangles = rbind(c(0.25,deriv_length)),add = T,inches = F,bg = 1)
        }
      }
    }
    symbols(x=50,y=50,add = T,inches = F,rectangles = rbind(c(plate_x,plate_y)),lty=2)
  }
  
  ## security
  # plate dim
  # too much bands ???
  # L too big

  # replace the parts
  step$gcode = gcode
  step$plot = plot_step
  step$info = c("Plate length and width must be 50 mm or 100 mm, nothing else\n",
                     "There is no security for bad values, be careful\n",
                     paste0("Band ",seq(nrow(deriv_table)),": ", deriv_table$I*Drop_vol*deriv_length*12*deriv_table$Repeat*path/1000," µL used; area = ",round(reso*12*deriv_length*reso)," mm2\n"))
  return(step)
}