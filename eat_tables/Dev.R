# eat_table_Dev = 
function(step){
  # eat_table_Dev function V01,21 february 2017
  # extract the needed information
  table = step$table
  
  inche = 25.4 # mm/inche
  dpi = 96
  reso = inche/dpi
  
  nozzle_X = 1;nozzle_Y = 12
  plate_X = 100;plate_Y=100
  ## empty array
  path = table[table[,1] == "path",2]
  Y=floor(plate_Y/reso/nozzle_Y)*nozzle_Y
  a = array(0,dim = c(Y,path))
  ## fill the array
  dist_bottom = ceiling(table[table[,1] == "dist_bottom",2]/reso)
  dist_top = ceiling(table[table[,1] == "dist_top",2]/reso)
  dist_gauche = ceiling(table[table[,1] == "dist_gauche",2]/reso)
  band_length = ceiling(table[table[,1] == "band_length",2]/reso)
  gap = ceiling(table[table[,1] == "gap",2]/reso)
  dist_gauche_saved = dist_gauche
  for(i in seq(table[table[,1] == "nbr_band",2])){
    a[dist_gauche:(dist_gauche+band_length),] = 1
    dist_gauche = dist_gauche+band_length+gap
  }
  
  b = array(0,dim=c(Y/nozzle_Y,dim(a)[2]))
  
  for(i in seq(path)){
    for(j in seq(Y/nozzle_Y)){
      b[j,i] = BinToDec(a[((j-1)*nozzle_Y+1):(j*nozzle_Y),i])
    }
  }
  
  start_gcode = c("G28 X0; home X axis",
                  "G28 Y0; home Y axis",
                  "G21 ; set units to millimeters",
                  "G90 ; use absolute coordinates",
                  paste0("G1 F",60*table[table[,1] == "speed",2]," ; set speed in mm per min for the movement"),
                  paste0("G1 Y",table[table[,1] == "dist_bottom",2]," ; go in Y position")
  )
  end_gcode = c("G28 X0; home X axis",
                "G28 Y0; home Y axis",
                "M84     ; disable motors")
  
  
  I = table[table[,1] == "I",2]
  W = table[table[,1] == "wait",2]
  L = table[table[,1] == "L",2]
  # gcode = b_to_gcode_X_fix(b,start_gcode,end_gcode,table[table[,2] == "I",3])
  ## get coord
  coordonate = list(
    X = round(seq(from=reso/2,by = reso,length.out = dim(b)[1]),4)
  )
  ## begin gcode
  gcode = start_gcode
  ## iterate
  for(k in seq(dim(b)[2])){ # path loop, need modulo for next loop
    if(k %% 2 == 1){
      s = seq(dim(b)[1])
    }else{
      s = seq(dim(b)[1]) %>% rev
    }
    for(j in s){
      if(b[j,k] != 0){
        gcode = c(gcode,paste0("G1 X",coordonate$X[j]," ; go in position")) ## 
        gcode = c(gcode,"M400 ; Wait for current moves to finish ")
        gcode = c(gcode,paste0("M700 P0 I",I," L",L," S",b[j,k]," ; Fire inkjet bits"))
      }
    }
    if(W != 0){gcode=c(gcode,paste0("G4 S",W,"; wait in seconds"))}
  }
  gcode = c(gcode,end_gcode)
  
  plot_step=function() {
    plot(c(1,100),c(1,dim(a)[1]),type="n",xlim=c(100,0),xlab="X",ylab="Y",main="Origin in upper right corner",sub="the origin is not the same as usual, I must fix it")
    rasterImage(1-apply(a,c(1),mean),xleft = table[table[,1] == "dist_bottom",2],xright=table[table[,1] == "dist_bottom",2]+0.5,ybottom = 1,ytop=dim(a)[1])
  }
  
  # replace the parts
  step$gcode = gcode
  step$plot = plot_step
  step$info = "Deprecated do not use"
  return(step)
}