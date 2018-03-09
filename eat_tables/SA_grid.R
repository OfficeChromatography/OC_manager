# eat_table_SA_grid= 
function(step){
  # eat_table_SA_grid function V011,29 may 2017
  ## print a grid of band like free mode in ATS4
  ## little different for the SA_table as the number of row is the number of band
  ## band are in X and row in Y
  # extract the needed information
  table = step$table;
  SA_table = step$appli_table
  colnames(step$appli_table)[1] = "Row"
  dist_gauche = table[table[,1] == "dist_gauche",2]
  band_length = table[table[,1] == "band_length",2]
  gap = table[table[,1] == "gap",2]
  speed = table[table[,1] == "speed",2]
  dist_bottom = table[table[,1] == "dist_bottom",2]
  nbr_band = table[table[,1] == "nbr_row",2] ## warning
  nbr_row = table[table[,1] == "nbr_band",2] ## warning
  row_Y_gap = table[table[,1] == "row_Y_gap",2]
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
                  paste0("G1 F",60*speed," ; set speed in mm per min for the movement"),
                  "G1 Y90"
  )
  end_gcode = c("G28 X0; home X axis",
                "G28 Y0; home Y axis",
                "M84     ; disable motors")
  ## previously function a_to_gcode_X_fix
  
  S = rep(0,12)
  for(i in seq(12)){if(i %in% as.numeric(nozzle)){S[i] = 1}};S = BinToDec(S)
  shift = round((1 - nozzle)*reso,3)
  Y_coord = c()
  for(i in seq(nbr_row)){
    Y_coord = c(Y_coord,(i-1)*row_Y_gap+shift+dist_bottom)
  }
  
  ## iterate
  gcode = c(start_gcode,unlist(lapply(seq(path),function(k){
    gcode = c()
    for(row in seq(nbr_row)){
      if(SA_table$Use[row]){
        for(Repeat in seq(SA_table$Repeat[row])){
          gcode = c(gcode,paste0("G1 Y",Y_coord[row]))
          I = SA_table$I[row]
          for(band in seq(nbr_band)){
            X_coord = round(seq(from = dist_gauche+(band-1)*(gap+band_length),by=reso,length.out = ceiling(band_length/reso)),3)
            for(i in X_coord){ # X loop, need modulo
              gcode = c(gcode,paste0("G1 X",i," ; go in position - path: ",k))
              gcode = c(gcode,"M400 ; Wait for current moves to finish ")
              gcode = c(gcode,paste0("M700 P0 I",I," L",L," S",S," ; Fire"))
            }
          }
        }
      }
    }
    if(W != 0){gcode=c(gcode,paste0("G4 S",W,"; wait in seconds"))}
    return(gcode)
  }
  )))
  gcode = c(gcode,end_gcode)
  
  plot_step=function() {
    plot(c(1,100),c(1,100),type="n",xlim=c(0,100),ylim=c(100,0),xlab="X",ylab="Y",main="Origin in upper left corner",sub=paste0(length(gcode)," GCODE commands"))
    for(row in seq(nbr_row)){
      if(SA_table$Use[row]){
        y = Y_coord[row]
        for(band in seq(nbr_band)){
          segments(y0 = y,
                   x0 = dist_gauche+shift+(band-1)*(gap+band_length),
                   x1 = dist_gauche+shift+(band-1)*(gap+band_length)+band_length)
        }
      }
    }
  }
  
  # replace the parts
  step$gcode = gcode
  step$plot = plot_step
  step$info = c("This step is for 10 by 10 plates,\nthe row are iterate in Y and the band in X\nCalcul is made with linomat conventions\n",
                paste0("Row ",seq(nrow(SA_table)),": Volume used per band: ", SA_table$I*0.1*ceiling(band_length/reso)*SA_table$Repeat*path/1000," µL\n")
  )
  return(step)
}