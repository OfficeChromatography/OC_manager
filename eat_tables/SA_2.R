# eat_table_SA_2 = 
function(step){
  # eat_table_SA_2 function V011,13 april 2017
  ## for 
  # extract the needed information
  table = step$table;
  SA_table = step$appli_table
  dist_gauche = table[table[,1] == "dist_gauche",2]
  band_length = table[table[,1] == "band_length",2]
  gap = table[table[,1] == "gap",2]
  speed = table[table[,1] == "speed",2]
  dist_bottom = table[table[,1] == "dist_bottom",2]
  # I=table[table[,1] == "I",2];
  path=table[table[,1] == "path",2];
  L=table[table[,1] == "L",2];
  W=table[table[,1] == "wait",2];
  nozzle = table[table[,1] == "nozzle",2]
  ## empty array
  inche = 25.4 # mm/inche
  dpi = 96
  reso = inche/dpi
  nozzle_Y = 1 ## use only one nozzle
  plate_Y=100
  
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
  ## previously function a_to_gcode_X_fix
  
  S = rep(0,12)
  for(i in seq(12)){if(i %in% as.numeric(nozzle)){S[i] = 1}};S = BinToDec(S)
  shift = round((1 - nozzle)*reso,3)
  
  ## begin gcode
  ## iterate
  gcode = c(start_gcode,unlist(lapply(seq(path),function(k){
    gcode = c()
    for(band in seq(nrow(SA_table))){
      Y_coord = round(seq(from = dist_gauche+shift+(band-1)*(gap+band_length),by=reso,length.out = ceiling(band_length/reso)),3)+25# 25 added so user doesn't care
      # gcode = c(gcode,paste0("G1 Y",dist_gauche+shift+(band-1)*(gap+band_length),"; go in Y position"))
      if(SA_table$Use[band]){
        I = SA_table$I[band]
        for(Repeat in seq(SA_table$Repeat[band])){
          for(i in Y_coord){ # X loop, need modulo
            gcode = c(gcode,paste0("G1 Y",i," ; go in position - path: ",k))
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
        segments(x0 = dist_bottom,
                 y0 = dist_gauche+shift+(band-1)*(gap+band_length)+25,
                 y1 = dist_gauche+shift+(band-1)*(gap+band_length)+band_length+25)
      }
    }
    abline(h=c(25,75),lty=2)
  }
  
  # replace the parts
  step$gcode = gcode
  step$plot = plot_step
  step$info = c("This method is for 5 by 10 plates in the multipurpose plate holder\nthe plate is store horizontally \nthe distance convention is made for the exterior of the plate\n",
                paste0("Band ",seq(nrow(SA_table)),": Volume used: ", SA_table$I*0.1*ceiling(band_length/reso)*SA_table$Repeat*path/1000," µL\n")
  )
  return(step)
}