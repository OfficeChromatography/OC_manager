# eat_table_Deriv_2 = 
function(step){
  # eat_table_Deriv_2 function V01.1, 28 march 2017
  # extract the needed information
  table = step$table
  inche = 25.4 # mm/inche
  dpi = 96
  reso = inche/dpi
  
  nozzle_X = 12;nozzle_Y = 1
  plate_X = 100;plate_Y=100
  ## empty array
  path = table[table[,1] == "path",2]
  X=floor(plate_X/reso/nozzle_X)*nozzle_X;Y=floor(plate_Y/reso/nozzle_Y)*nozzle_Y
  a = array(0,dim = c(X,Y,path))
  ## fill the array
  X_bias = ceiling(table[table[,1] == "X_bias",2]/reso)
  X_center = X - (ceiling(table[table[,1] == "X_center",2]/reso) + X_bias)
  X_width = ceiling(table[table[,1] == "X_width",2]/reso)
  Y_center = ceiling(table[table[,1] == "Y_center",2]/reso)
  Y_width = ceiling(table[table[,1] == "Y_width",2]/reso)
  
  ## very messy here to incorporate the new convention
  dist_bottom = X_center - X_width/2
  dist_top = X_center + X_width/2
  dist_gauche = Y_center - Y_width/2
  band_length = Y_width
  # gap = ceiling(table[table[,1] == "gap",2]/reso)
  # nbr_band = table[table[,1] == "nbr_band",2]
  # dist_gauche_saved = dist_gauche
  # for(i in seq(nbr_band)){
  a[dist_gauche:(dist_gauche+band_length),dist_bottom:dist_top,] = 1 ## X/Y inverse, 
  # dist_gauche = dist_gauche+band_length+gap
  # }
  
  ## previously a_to_b
  path=dim(a)[3]
  ## redim array
  b = array(0,dim=c(X/nozzle_X,Y,dim(a)[3]))
  for(i in seq(path)){
    for(j in seq(X/nozzle_X)){
      for(k in seq(Y/nozzle_Y)){
        b[j,k,i] = BinToDec(a[((j-1)*nozzle_X+1):(j*nozzle_X),k,i])
      }
    }
  }
  
  ## previously b_to_gcode
  I = table[table[,1] == "I",2];L=table[table[,1] == "L",2];direction=table[table[,1] == "direction",2]
  start_gcode = c("G28 X0; home X axis",
                  "G28 Y0; home Y axis",
                  "G21 ; set units to millimeters",
                  "G90 ; use absolute coordinates",
                  paste0("G1 F",60*table[table[,1] == "speed",2]," ; set speed in mm per min for the movement")
  )
  end_gcode = c("G28 X0; home X axis",
                "G28 Y0; home Y axis",
                "M84     ; disable motors")
  ## get coord
  coordonate = list(
    X = round(seq(from=reso*nozzle_X/2+reso/2,by=reso*12,length.out = dim(b)[1]),4),
    Y = round(seq(from=reso/2,by = reso,length.out = dim(b)[2]),4)
  )
  ## begin gcode
  gcode = start_gcode
  ## iterate
  if(direction == 0){
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
            gcode = c(gcode,paste0("G1 Y",coordonate$X[i]," X",coordonate$Y[j]," ; go in position")) ## X and Y are inversed, carefull
            gcode = c(gcode,"M400 ; Wait for current moves to finish ")
            gcode = c(gcode,paste0("M700 P0 I",I," L",L," S",b[i,j,k]," ; Fire inkjet bits"))
          }
        }
      }
    }
  }else{
    for(k in seq(dim(b)[3])){ # slice loop, need modulo for next loop
      if(k %% 2 == 1){
        s = seq(dim(b)[2])
      }else{
        s = seq(dim(b)[2]) %>% rev
      }
      for(i in s){ # X loop, need modulo
        if(i %% 2 == 1){
          s = seq(dim(b)[1])
        }else{
          s = seq(dim(b)[1]) %>% rev
        }
        for(j in s){
          if(b[j,i,k] != 0){
            gcode = c(gcode,paste0("G1 Y",coordonate$X[j]," X",coordonate$Y[i]," ; go in position")) ## X and Y are inversed, carefull
            gcode = c(gcode,"M400 ; Wait for current moves to finish ")
            gcode = c(gcode,paste0("M700 P0 I",I," L",L," S",b[j,i,k]," ; Fire inkjet bits"))
          }
        }
      }
    }
  }
  
  gcode = c(gcode,end_gcode)
  # b_to_gcode(b,start_gcode,end_gcode,table[table[,2] == "I",3])
  
  plot_step=function() {
    plot(c(1,100),c(1,100),type="n",xlim=c(0,100),ylim=c(100,0),xlab="X",ylab="Y",main="(0,0) in upper right")
    rasterImage(1-apply(a,c(1,2),mean),ybottom = 100,ytop=0,xleft = 1,xright=100) ## X/Y inverse, 
    abline(v=c(X_bias*reso,100-X_bias*reso),lty=2)
    # DLC::raster(1-apply(a,c(1,2),mean),xaxs="i",yaxs="i")
  }
  
  # replace the parts
  step$gcode = gcode
  step$plot = plot_step
  step$info = paste0("Volume used: ", I*0.1*X_width*Y_width/1000," µL")
  return(step)
}