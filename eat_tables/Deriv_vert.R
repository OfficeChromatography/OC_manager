# eat_table_Deriv_vert = 
function(step){
  # eat_table_Deriv_vert function V01,16 march 2017
  # extract the needed information
  table = step$table
  inche = 25.4 # mm/inche
  dpi = 96
  reso = inche/dpi
  
  nozzle_X = 1;nozzle_Y = 12
  plate_X = 100;plate_Y=100
  ## empty array
  path = table[table[,1] == "path",2]
  X=floor(plate_X/reso/nozzle_X)*nozzle_X;Y=floor(plate_Y/reso/nozzle_Y)*nozzle_Y
  a = array(0,dim = c(X,Y,path))
  ## fill the array
  dist_bottom = ceiling(table[table[,1] == "dist_bottom",2]/reso)
  dist_top = ceiling(table[table[,1] == "dist_top",2]/reso)
  dist_gauche = ceiling(table[table[,1] == "dist_gauche",2]/reso)
  band_length = ceiling(table[table[,1] == "band_length",2]/reso)
  gap = ceiling(table[table[,1] == "gap",2]/reso)
  nbr_band = table[table[,1] == "nbr_band",2]
  dist_gauche_saved = dist_gauche
  for(i in seq(nbr_band)){
    a[dist_bottom:dist_top,dist_gauche:(dist_gauche+band_length),] = 1 ## X/Y inverse, 
    dist_gauche = dist_gauche+band_length+gap
  }
  #raster(a[,,1])
  dist_gauche = dist_gauche_saved
  ## previously a_to_b
  path=dim(a)[3]
  ## redim array
  b = array(0,dim=c(X/nozzle_X,Y/nozzle_Y,dim(a)[3]))
  for(i in seq(path)){
    for(j in seq(X/nozzle_X)){
      for(k in seq(Y/nozzle_Y)){
        b[j,k,i] = BinToDec(a[((j-1)*nozzle_X+1):(j*nozzle_X),((k-1)*nozzle_Y+1):(k*nozzle_Y),i])
      }
    }
  }
  raster(b[,,1]%>%normalize)
  ## previously b_to_gcode
  I = table[table[,1] == "I",2];L=table[table[,1] == "L",2];speed = 60*table[table[,1] == "speed",2]
  start_gcode = c("G28 X0; home X axis",
                  "G28 Y0; home Y axis",
                  "G21 ; set units to millimeters",
                  "G90 ; use absolute coordinates",
                  paste0("G1 F",speed," ; set speed in mm per min for the movement")
  )
  end_gcode = c("G28 X0; home X axis",
                "G28 Y0; home Y axis",
                "M84     ; disable motors")
  ## get coord
  coordonate = list(
    X = round(seq(from=reso*nozzle_X/2+reso/2,by=reso*nozzle_X,length.out = dim(b)[1]),4),
    Y = round(seq(from=reso*nozzle_Y/2+reso/2,by = reso*nozzle_Y,length.out = dim(b)[2]),4)
  )
  ## begin gcode
  gcode = start_gcode
  ## iterate
  for(k in seq(dim(b)[3])){ # slice loop, need modulo for next loop
    if(k %% 2 == 1){
      s = seq(dim(b)[1])
    }else{
      s = seq(dim(b)[1]) %>% rev
    }
    for(i in s){ # X loop, need modulo
      if(i %% 2 == 1){
        s = seq(dim(b)[2])
      }else{
        s = seq(dim(b)[2]) %>% rev
      }
      for(j in s){
        if(b[i,j,k] != 0){
          gcode = c(gcode,paste0("G1 X",coordonate$X[i]," Y",coordonate$Y[j]," ; go in position")) ## X and Y are inversed, carefull
          gcode = c(gcode,"M400 ; Wait for current moves to finish ")
          gcode = c(gcode,paste0("M700 P0 I",I," L",L," S",b[i,j,k]," ; Fire inkjet bits"))
        }
      }
    }
  }
  gcode = c(gcode,end_gcode)
  # b_to_gcode(b,start_gcode,end_gcode,table[table[,2] == "I",3])
  
  plot_step=function() {
    plot(c(1,100),c(1,100),type="n",xlim=c(0,100),ylim=c(100,0),xlab="X",ylab="Y",main="Origin in upper left corner",sub="the origin is not the same as usual, I must fix it")
    rasterImage(1-apply(a,c(1,2),mean),ybottom = 1,ytop=100,xleft = 1,xright=100) ## X/Y inverse, 
    # DLC::raster(1-apply(a,c(1,2),mean),xaxs="i",yaxs="i")
  }
  
  # replace the parts
  step$gcode = gcode
  step$plot = plot_step
  step$info = "still not but incomming"
  return(step)
}