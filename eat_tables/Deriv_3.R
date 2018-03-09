# eat_table_Deriv_3 = 
function(step){
  # eat_table_Deriv_3 function V01.1, 29 march 2017
  # simple line in the X direction
  # extract the needed information
  table = step$table;SA_table = step$appli_table
  inche = 25.4 # mm/inche
  dpi = 96
  reso = inche/dpi
  
  nozzle_X = 1
  plate_X = 100;plate_Y=100
  ## empty array
  X=floor(plate_X/reso/nozzle_X)*nozzle_X
  a = rep(0,X)
  ## extract info from table
  X_center = (ceiling(table[table[,1] == "X_center",2]/reso))
  X_width = ceiling(table[table[,1] == "X_width",2]/reso)
  Y_center = table[table[,1] == "Y_center",2]
  gap = table[table[,1] == "gap",2]
  L=table[table[,1] == "L",2];speed = 60*table[table[,1] == "speed",2]
  path = table[table[,1] == "path",2]
  
  ## very messy here to incorporate the new convention
  dist_bottom = X_center - X_width/2
  dist_top = X_center + X_width/2
  a[dist_bottom:dist_top] = 1
  
  
  ## previously b_to_gcode
  
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
    X = round(seq(from=reso/2,by=reso,length.out = length(a)),4)
  )
  ## begin gcode
  ## iterate
  gcode = c(start_gcode,unlist(lapply(seq(path),function(k){
    gcode = c()
    for(band in seq(nrow(SA_table))){
      gcode = c(gcode,
                paste0("G1 Y",Y_center+(band-1)*gap,"; go in Y position"))
      if(SA_table$Use[band]){
        I = SA_table$I[band]
        for(Repeat in seq(SA_table$Repeat[band])){
          s = seq(length(a))
          for(i in s){ # X loop, need modulo
            if(a[i] != 0){
              gcode = c(gcode,paste0("G1 X",coordonate$X[i]," ; go in position"))
              gcode = c(gcode,"M400 ; Wait for current moves to finish ")
              gcode = c(gcode,paste0("M700 P0 I",I," L",L," S",4095," ; Fire all inkjet bits"))
            }
          }
        }
      }
    }
    gcode
  })))
  
  gcode = c(gcode,end_gcode)
  # b_to_gcode(b,start_gcode,end_gcode,table[table[,2] == "I",3])
  
  plot_step=function() {
    plot(c(1,100),c(1,100),type="n",xlim=c(0,100),ylim=c(100,0),xlab="X",ylab="Y",main="development in X direction\nfor saturation chamber")
    for(band in seq(nrow(SA_table))){
      if(SA_table$Use[band]){
        symbols(x=table[table[,1] == "X_center",2],y=Y_center+(band-1)*gap,rectangles = rbind(c(table[table[,1] == "X_width",2],3)),add = T,inches = F,bg = 1)
      }
    }
    abline(h=c(24,100-24),lty=2,lwd=2)
    # rasterImage(1-apply(a,c(1,2),mean),ybottom = 100,ytop=0,xleft = 1,xright=100) ## X/Y inverse, 
    # abline(v=c(X_bias*reso,100-X_bias*reso),lty=2)
    # DLC::raster(1-apply(a,c(1,2),mean),xaxs="i",yaxs="i")
  }
  
  # replace the parts
  step$gcode = gcode
  step$plot = plot_step
  step$info = paste0("Band ",seq(nrow(SA_table)),": Volume used: ", SA_table$I*0.1*X_width*12*SA_table$Repeat*path/1000," µL ; area = ",reso*12*X_width*reso," mm2\n")
  return(step)
}