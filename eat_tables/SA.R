# eat_table_SA = 
function(step){
  # eat_table_SA function V012,14 march 2017
  # extract the needed information
  table = step$table;SA_table = step$appli_table
  dist_gauche = table[table[,1] == "dist_gauche",2]
  band_length = table[table[,1] == "band_length",2]
  gap = table[table[,1] == "gap",2]
  speed = table[table[,1] == "speed",2]
  dist_bottom = table[table[,1] == "dist_bottom",2]
  I=table[table[,1] == "I",2];
  L=table[table[,1] == "L",2];
  W=table[table[,1] == "wait",2];
  nozzle = table[table[,1] == "nozzle",2]
  ## empty array
  inche = 25.4 # mm/inche
  dpi = 96
  reso = inche/dpi
  # nozzle_Y = 12 ## X/Y inverse, 
  nozzle_X = 1 ## X/Y inverse, 
  plate_X=100
  path = max(SA_table[,3])
  X=floor(plate_X/reso/nozzle_X)*nozzle_X## X/Y inverse, 
  a = array(0,dim = c(X,path))
  ## fill the array
  dist_gauche = ceiling(dist_gauche/reso)
  band_length = ceiling(band_length/reso)
  gap = ceiling(gap/reso)
  dist_gauche_saved = dist_gauche
  for(i in seq(nrow(SA_table))){
    if(SA_table$Use[i]){
      a[dist_gauche:(dist_gauche+band_length),1:SA_table$Repeat[i]] = 1
    }
    dist_gauche = dist_gauche+band_length+gap
    if(dist_gauche+band_length > X){ break()}
  }
  shift = round((1 - nozzle)*reso,3)
  
  start_gcode = c("G28 X0; home X axis",
                  "G28 Y0; home Y axis",
                  "G21 ; set units to millimeters",
                  "G90 ; use absolute coordinates",
                  paste0("G1 F",60*speed," ; set speed in mm per min for the movement"),
                  paste0("G1 Y",dist_bottom+shift," ; go in Y position") ## X/Y inverse, include shift
  )
  end_gcode = c("G28 X0; home X axis",
                "G28 Y0; home Y axis",
                "M84     ; disable motors")
  ## previously function a_to_gcode_X_fix
  
  S = rep(0,12)
  if(nozzle == 13){
    S = 4095
  }else{
    for(i in seq(12)){if(i %in% as.numeric(nozzle)){S[i] = 1}};S = BinToDec(S)
  }
  
  
  ## get coord
  coordonate = list(
    X = round(seq(from=reso/2,by = reso*nozzle_X,length.out = dim(a)[1]),3) ## X/Y inverse, remove shift
  )
  ## begin gcode
  gcode = start_gcode
  ## iterate
  for(k in seq(dim(a)[2])){ # path loop, need modulo for next loop
    if(sum(a[,k]) != 0){
      if(k %% 2 == 1){
        s = seq(dim(a)[1])
      }else{
        s = seq(dim(a)[1]) %>% rev
      }
      for(j in s){
        if(a[j,k] != 0){
          gcode = c(gcode,paste0("G1 X",coordonate$X[j]," ; go in position")) ## X/Y inverse, 
          gcode = c(gcode,"M400 ; Wait for current moves to finish ")
          gcode = c(gcode,paste0("M700 P0 I",I," L",L," S",S," ; Fire inkjet bits"))
        }
      }
      if(W != 0){gcode=c(gcode,paste0("G4 S",W,"; wait in seconds"))}
    }
  }
  gcode = c(gcode,end_gcode)
  
  
  plot_step=function() {
    plot(c(1,100),c(1,100),type="n",xlim=c(0,100),ylim=c(100,0),xlab="X",ylab="Y",main="Origin in upper left corner",sub="the origin is not the same as usual, I must fix it")
    rasterImage(t(1-apply(a,c(1),mean)),ybottom = dist_bottom,ytop=dist_bottom+0.5,xleft = 1,xright=100) ## X/Y inverse, 
    # abline(v=seq(from=1,to=100,by=10))
  }
  
  # replace the parts
  step$gcode = gcode
  step$plot = plot_step
  step$info = "still not but incomming"
  return(step)
}