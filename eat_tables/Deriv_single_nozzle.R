# eat_table_Deriv_single_nozzle = 
function(step){
  # eat_table_Deriv_single_nozzle V01,7 may 2017
  ## print derivatisation reagent with a single nozzle
  ## bands are in X
  # extract the needed information
  table = step$table;
  SA_table = step$appli_table
  dist_gauche = table[table[,1] == "dist_gauche",2]
  gap = table[table[,1] == "gap",2]
  speed = table[table[,1] == "speed",2]
  dist_bottom = table[table[,1] == "dist_bottom",2]
  dist_top = table[table[,1] == "dist_top",2]
  nbr_band = table[table[,1] == "nbr_band",2] ## warning
  # I=table[table[,1] == "I",2];
  path=table[table[,1] == "path",2];
  L=table[table[,1] == "L",2];
  W=table[table[,1] == "wait",2];
  nozzle = table[table[,1] == "nozzle",2]
  ## empty array
  inche = 25.4 # mm/inche
  dpi = 96
  reso = inche/dpi
  
  start_gcode = c("G28 X0; home X axis",
                  "G28 Y0; home Y axis",
                  "G21 ; set units to millimeters",
                  "G90 ; use absolute coordinates",
                  paste0("G1 F",60*speed," ; set speed in mm per min for the movement")
  )
  end_gcode = c("G28 X0; home X axis",
                "G28 Y0; home Y axis",
                "M84     ; disable motors")
  
  S = rep(0,12)
  for(i in seq(12)){if(i %in% as.numeric(nozzle)){S[i] = 1}};S = BinToDec(S)
  shift = round((1 - nozzle)*reso,3)
  
  Y_coord = round(seq(from = dist_bottom,to = dist_top,by=reso),3) + shift
  
  ## iterate
  gcode = c(start_gcode,unlist(lapply(seq(path),function(k){
    gcode = c()
    for(band in seq(nrow(SA_table))){
      gcode = c(gcode,paste0("G1 X",dist_gauche+(band-1)*(gap),"; go in X"))
      if(SA_table$Use[band]){
        I = SA_table$I[band]
        for(Repeat in seq(SA_table$Repeat[band])){
          for(i in Y_coord){ # X loop, need modulo
            gcode = c(gcode,paste0("G1 Y",i," ; go in position - path: ",k)) ## reinsert k here
            gcode = c(gcode,"M400 ; Wait for current moves to finish ")
            gcode = c(gcode,paste0("M700 P0 I",I," L",L," S",S," ; Fire"))
          }
        }
      }
    }
    if(W != 0){gcode=c(gcode,paste0("G4 S",W,"; wait in seconds"))}
    return(gcode)
  }))
  )
  # for(k in seq(path)){
  #   for(band in seq(nrow(SA_table))){
  #     gcode = c(gcode,paste0("G1 X",dist_gauche+(band-1)*(gap),"; go in X"))
  #     if(SA_table$Use[band]){
  #       I = SA_table$I[band]
  #       for(Repeat in seq(SA_table$Repeat[band])){
  #         for(i in Y_coord){ # X loop, need modulo
  #           gcode = c(gcode,paste0("G1 Y",i," ; go in position - path: ",k))
  #           gcode = c(gcode,"M400 ; Wait for current moves to finish ")
  #           gcode = c(gcode,paste0("M700 P0 I",I," L",L," S",S," ; Fire"))
  #         }
  #       }
  #     }
  #   }
  #   if(W != 0){gcode=c(gcode,paste0("G4 S",W,"; wait in seconds"))}
  # }
  gcode = c(gcode,end_gcode)
  
  plot_step=function() {
    plot(c(1,100),c(1,100),type="n",xlim=c(0,100),ylim=c(100,0),xlab="X",ylab="Y",main="Origin in upper left corner",sub=paste0(length(gcode)," GCODE commands"))
    for(band in seq(nrow(SA_table))){
      if(SA_table$Use[band]){
        segments(y0 = dist_bottom,
                 y1 = dist_top,
                 x0 = dist_gauche+(band-1)*(gap)
        )
      }
    }
  }
  
  # replace the parts
  step$gcode = gcode
  step$plot = plot_step
  step$info = c("This method is for 10 by 10 plates in the heated plate holder\nband are in X and development in Y\n",
                paste0("Band ",seq(nrow(SA_table)),": Volume used: ", SA_table$I*0.1*ceiling((dist_top - dist_bottom)/reso)*SA_table$Repeat*path/1000," µL\n")
  )
  return(step)
}