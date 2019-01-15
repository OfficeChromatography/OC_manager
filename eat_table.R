## function eat table for OC_manager

need_appli = c("SA","Dev","Deriv","Deriv_3","SA_2","SA_in_X","SA_grid","Deriv_single_nozzle")

eat_table_LP = function(step){
  # eat_table_LP function V011,24 february 2017
  # extract the needed information
  table = step$table
  gap = table[table[,1] == "gap",2]
  nbr_track = table[table[,1] == "nbr_track",2]
  nbr_path = table[table[,1] == "nbr_path",2]
  gap_path = table[table[,1] == "gap_path",2]
  Y_length = table[table[,1] == "Y_length",2]
  bottom_dist = table[table[,1] == "bottom_dist",2]
  first_appli=table[table[,1] == "first_appli",2]
  syringe_ratio = table[table[,1] == "syringe_ratio",2]
  microL_per_dm = table[table[,1] == "microL_per_dm",2]
  temp = 0
  speed = table[table[,1] == "speed",2]
  Z_offset = table[table[,1] == "Z_offset",2]
  
  
  
  track_gap = gap - (nbr_path-1)*gap_path
  if(nbr_path != 1  && nbr_track != 1){
    validate(need(track_gap > gap_path,"the track gap in <= to the path gap"))
  }
  # validate(need(input$LP_Y_length<=100,"Y_length > 100"))
  Y_small = bottom_dist
  Y_big = bottom_dist + Y_length
  X_gap = c()
  for(i in seq(nbr_track)){
    X_gap = c(X_gap,rep(gap_path,nbr_path-1))
    X_gap = c(X_gap,track_gap)
  }
  mat  =rbind(c(NA,NA,first_appli - (nbr_path-1)/2*gap_path,Y_small,0))
  for(i in seq(length(X_gap))){
    vec = c(mat[nrow(mat),3],mat[nrow(mat),4],mat[nrow(mat),3],0,0) 
    if(mat[nrow(mat),4] == Y_small){vec[4] = Y_big}else{vec[4] = Y_small}
    vec[5] = mat[nrow(mat),5] + abs(vec[2] - vec[4]) /100 * microL_per_dm / 1000 * syringe_ratio
    # print(vec)
    mat  =rbind(mat,vec)
    if(i != length(X_gap)){
      vec = c(vec[3],vec[4],vec[3]+X_gap[i],vec[4],vec[5])
      vec[5] = vec[5] + abs(vec[1] - vec[3]) /100 * microL_per_dm / 1000 * syringe_ratio
      # print(vec)
      mat  =rbind(mat,vec)
    }
  }
  mat[,5] = round(mat[,5],5)
  LP_applications = mat
  
  plot_step=function() {
    plot(x=0,y=0,type="n",xlim=c(0,100),ylim=c(0,100),xlab="X",ylab="Y",sub = "note that the plate is reversed on the printer")
    segments(x0=LP_applications[,1],x1 = LP_applications[,3],y0 = LP_applications[,2],y1 = LP_applications[,4])
  }
  
  gcode = c(
    #paste0("; Produce with OC_manager, ",date()),
    "G28 ; home all axis, will have a problem with the Z",
    "G29 ; perform bed levelling",
    "G21 ; set units to millimeters",
    "G90 ; use absolute coordinates",
    "M82 ; use absolute distances for extrusion",
    "G92 E0",
    paste0("G1 F",60*speed," ; set speed in mm per min for the movement"))
  if(Z_offset >0){
    gcode = c(gcode,paste0("G1 Z",Z_offset," ; go in Z offset position"))
  }else{
    gcode = c(gcode,
            paste0("G92 Z",-Z_offset," ; force the Z offset"),
            paste0("G1 Z",0," ; go in Z offset position")
    )
  }
  if(temp != 0){gcode = c(gcode,paste0("M190 S",temp," ; set temperature"))}
  gcode = c(gcode,
          paste0("G1 X",LP_applications[1,3]," Y",LP_applications[1,4]," ; go in first position"),
          "M400; wait for current move to finish"
  )
  for(i in 2:nrow(LP_applications)){
    gcode <- c(gcode,
               paste0("G1 X",LP_applications[i,3]," Y",LP_applications[i,4]," E",LP_applications[i,5]),
               "M400; wait for current move to finish")
  }
  gcode = c(gcode,"G92 E0",
           "G1 Z5; move Z 5 mm upper",
           paste0("G1 E-",LP_applications[nrow(LP_applications),5]+10,"; move the piston pusher up"),
           "M84     ; disable motors")
  

  # replace the parts
  step$gcode = gcode
  step$plot = plot_step
  step$info = c(paste0("Track are ",(nbr_path-1)*gap_path," mm large (without counting the outside)\n"),
                paste0("Track are ",(nbr_path)*gap_path," mm large (counting the outside)\n"),
                paste0("Surface is ",(nbr_path)*gap_path*nbr_track*Y_length," mm2 large (counting the outside), 1 dm2 = 10000 mm2\n"),
                paste0((LP_applications[nrow(LP_applications),5] / syringe_ratio)," mL use in this print")
                )
  return(step)
}

eat_table_LP_2 = function(step){
  # eat_table_LP_2 function V01,13 june 2017
  # For layerLab: no Z axis, no temp
  # extract the needed information
  table = step$table
  gap = table[table[,1] == "gap",2]
  nbr_track = table[table[,1] == "nbr_track",2]
  nbr_path = table[table[,1] == "nbr_path",2]
  gap_path = table[table[,1] == "gap_path",2]
  Y_length = table[table[,1] == "Y_length",2]
  bottom_dist = table[table[,1] == "bottom_dist",2]
  first_appli=table[table[,1] == "first_appli",2]
  syringe_ratio = table[table[,1] == "syringe_ratio",2]
  microL_per_dm = table[table[,1] == "microL_per_dm",2]
  speed = table[table[,1] == "speed",2]
  X_bias = table[table[,1] == "X_bias",2]
  
  track_gap = gap - (nbr_path-1)*gap_path
  if(nbr_path != 1  && nbr_track != 1){
    validate(need(track_gap > gap_path,"the track gap in <= to the path gap"))
  }
  # validate(need(input$LP_Y_length<=100,"Y_length > 100"))
  Y_small = bottom_dist
  Y_big = bottom_dist + Y_length
  X_gap = c()
  for(i in seq(nbr_track)){
    X_gap = c(X_gap,rep(gap_path,nbr_path-1))
    X_gap = c(X_gap,track_gap)
  }
  mat  =rbind(c(NA,NA,first_appli - (nbr_path-1)/2*gap_path,Y_small,0))
  for(i in seq(length(X_gap))){
    vec = c(mat[nrow(mat),3],mat[nrow(mat),4],mat[nrow(mat),3],0,0) 
    if(mat[nrow(mat),4] == Y_small){vec[4] = Y_big}else{vec[4] = Y_small}
    vec[5] = mat[nrow(mat),5] + abs(vec[2] - vec[4]) /100 * microL_per_dm / 1000 * syringe_ratio
    # print(vec)
    mat  =rbind(mat,vec)
    if(i != length(X_gap)){
      vec = c(vec[3],vec[4],vec[3]+X_gap[i],vec[4],vec[5])
      vec[5] = vec[5] + abs(vec[1] - vec[3]) /100 * microL_per_dm / 1000 * syringe_ratio
      # print(vec)
      mat  =rbind(mat,vec)
    }
  }
  mat[,5] = round(mat[,5],5)
  LP_applications = mat
  
  plot_step=function() {
    plot(x=0,y=0,type="n",xlim=c(0,100),ylim=c(0,100),xlab="X",ylab="Y",sub = "note that the plate is reversed on the printer")
    segments(x0=LP_applications[,1],x1 = LP_applications[,3],y0 = LP_applications[,2],y1 = LP_applications[,4])
  }
  
  gcode = c(
    #paste0("; Produce with OC_manager, ",date()),
    "M400",
    "G28 X0",
    "M400",
    "G28 Y0",
    "G21",
    "G90",
    "G92 E0",
    "M400",
    paste0("G1 F",60*speed))
  gcode = c(gcode,
            paste0("G1 X",LP_applications[1,3]+X_bias," Y",LP_applications[1,4]),
            "M400"
  )
  for(i in 2:nrow(LP_applications)){
    gcode <- c(gcode,
               paste0("G1 X",LP_applications[i,3]+X_bias," Y",LP_applications[i,4]," E",LP_applications[i,5]),
               "M400"#,
               #"G4 P1"
    )
  }
  gcode = c(gcode,"G92 E0",
            "G28 Y0",
            "G28 X0",
            "M84")
  
  
  # replace the parts
  step$gcode = gcode
  step$plot = plot_step
  step$info = c(paste0("Track are ",(nbr_path-1)*gap_path," mm large (without counting the outside)\n"),
                paste0("Track are ",(nbr_path)*gap_path," mm large (counting the outside)\n"),
                paste0("Surface is ",(nbr_path)*gap_path*nbr_track*Y_length," mm2 large (counting the outside), 1 dm2 = 10000 mm2\n"),
                paste0((LP_applications[nrow(LP_applications),5] / syringe_ratio)," mL use in this print\n"),
                paste0((LP_applications[nrow(LP_applications),5] / syringe_ratio)/((nbr_path)*gap_path*nbr_track*Y_length)*10000," mL/dm2")
  )
  return(step)
}


eat_table_Dev = function(step){
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

eat_table_Dev_2 = function(step){
  ## eat_table_Dev_2 function V01,19 april 2017
  # in each position, we fire every body, no need for nozzles
  ## extract the needed information
  table = step$table
  
  inche = 25.4 # mm/inche
  dpi = 96
  reso = round(inche/dpi,3)
  
  ## empty array
  path = table[table[,1] == "path",2]
  X = table[table[,1] == "X",2]
  Y_left = table[table[,1] == "Y_left",2] +25
  Y_right = table[table[,1] == "Y_right",2] +25
  speed = table[table[,1] == "speed",2]
  I = table[table[,1] == "I",2]
  L = table[table[,1] == "L",2]
  wait = table[table[,1] == "wait",2]
  wait_inc = table[table[,1] == "wait_inc",2]
  
  S = 4095 ## may be integrate it for later in the table
  
  wait_vec = c()
  for(i in seq(path)){
    wait_vec = c(wait_vec,round(wait,3))
    wait = wait*wait_inc
  }
  timing = ((Y_right-Y_left)/speed*2+(Y_right-Y_left)/reso*I*0.9/1000)
  
  start_gcode = c("G28 X0; home X axis",
                  "G28 Y0; home Y axis",
                  "G21 ; set units to millimeters",
                  "G90 ; use absolute coordinates",
                  paste0("G1 F",60*speed," ; set speed in mm per min for the movement"),
                  paste0("G1 X",X," ; go in X position")
  )
  end_gcode = c("G28 X0; home X axis",
                "G28 Y0; home Y axis",
                "M84     ; disable motors")
  
  ## begin gcode
  gcode = c(start_gcode,unlist(lapply(seq(path),function(k){
    gcode = c()
    Y = Y_left
    for(i in seq((Y_right-Y_left)/reso)){
      gcode = c(gcode,
                paste0("G1 Y",Y," ; go in first Y position"),
                "M400 ; Wait for current moves to finish ",
                paste0("M700 P0 I",I," L",L," S",S," ; Fire inkjet bits")
                )
      Y = Y +reso
    }
    if(wait != 0){gcode=c(gcode,paste0("G4 S",wait_vec[k],"; wait in seconds"))}
    gcode
  })))
  gcode = c(gcode,end_gcode)
  
  ## plot, need recall of Y positions
  # Y_left = table[table[,1] == "Y_left",2]
  # Y_right = table[table[,1] == "Y_right",2]
  wait = table[table[,1] == "wait",2]
  plot_step=function() {
    par(mfrow=c(1,2))
    plot(c(1,100),c(1,100),ylim=c(100,0),xlim=c(0,100),type="n",xlab="X",ylab="Y",main="Origin in upper left corner",sub="Y = X, convention, convention...")
    segments(x0=X,y0=Y_left,y1=Y_right)
    plot(wait_vec,ylim= c(0,max(wait_vec)),main="Dwell time evolution",ylab="dwell time (sec)",xlab="path")
    abline(h=c(25,75),lty=2)
  }
  
  timing = timing*path + sum(wait_vec)
  # replace the parts
  step$gcode = gcode
  step$plot = plot_step
  step$info = c("for plate of 50*100 mm.\n","application on the left side\n","Same as SA_2\n",
                paste0("Volume used (µL): ",round(I*12*0.1/1000*(Y_right-Y_left)/reso*path,3),"\n"),
                paste0("Estimated time: ",round(timing), " sec = ",round(timing/60,2)," min"))
  return(step)
}

eat_table_Dev_in_X = function(step){
  ## eat_table_Dev_in_X function V01,26 april 2017
  # in each position, we fire every body, no need for nozzles
  ## extract the needed information
  table = step$table
  
  inche = 25.4 # mm/inche
  dpi = 96
  reso = round(inche/dpi,3)
  
  ## empty array
  path = table[table[,1] == "path",2]
  Y = table[table[,1] == "Y",2] + 25
  X_left = table[table[,1] == "X_left",2] 
  X_right = table[table[,1] == "X_right",2] 
  speed = table[table[,1] == "speed",2]
  I = table[table[,1] == "I",2]
  L = table[table[,1] == "L",2]
  wait = table[table[,1] == "wait",2]
  wait_inc = table[table[,1] == "wait_inc",2]
  return = table[table[,1] == "return",2]
  
  S = 4095 ## may be integrate it for later in the table
  
  wait_vec = c()
  for(i in seq(path)){
    wait_vec = c(wait_vec,round(wait,3))
    wait = wait*wait_inc
  }
  timing = ((X_right-X_left)/speed*2+(X_right-X_left)/reso*I*0.9/1000)
  
  start_gcode = c("G28 X0; home X axis",
                  "G28 Y0; home Y axis",
                  "G21 ; set units to millimeters",
                  "G90 ; use absolute coordinates",
                  paste0("G1 F",60*speed," ; set speed in mm per min for the movement"),
                  paste0("G1 Y",Y-reso*6.5," ; go in Y position")
  )
  end_gcode = c("G28 X0; home X axis",
                "G28 Y0; home Y axis",
                "M84     ; disable motors")
  
  ## begin gcode
  gcode = c(start_gcode,unlist(lapply(seq(path),function(k){
    gcode = c()
    X = X_left
    for(i in seq((X_right-X_left)/reso)){
      gcode = c(gcode,
                paste0("G1 X",X," ; go in X position"),
                "M400 ; Wait for current moves to finish ",
                paste0("M700 P0 I",I," L",L," S",S," ; Fire inkjet bits")
      )
      X = X + reso
    }
    if(wait != 0){gcode=c(gcode,paste0("G4 S",wait_vec[k],"; wait in seconds"))}
    if(return != 0){
      X = X_right
      for(i in seq((X_right-X_left)/reso)){
        gcode = c(gcode,
                  paste0("G1 X",X," ; go in X position"),
                  "M400 ; Wait for current moves to finish ",
                  paste0("M700 P0 I",I," L",L," S",S," ; Fire inkjet bits")
        )
        X = X - reso
      }
      if(wait != 0){gcode=c(gcode,paste0("G4 S",wait_vec[k],"; wait in seconds"))}
    }
    gcode
  })))
  gcode = c(gcode,end_gcode)
  
  ## plot, need recall of Y positions
  X_left = table[table[,1] == "X_left",2]
  X_right = table[table[,1] == "X_right",2]
  # Y = table[table[,1] == "Y",2]
  wait = table[table[,1] == "wait",2]
  plot_step=function() {
    par(mfrow=c(1,2))
    plot(c(1,100),c(1,100),ylim=c(100,0),xlim=c(0,100),type="n",xlab="X",ylab="Y",main="Origin in upper left corner")
    segments(x0=X_left,x1=X_right,y0=Y)
    plot(wait_vec,ylim= c(0,max(wait_vec)),main="Dwell time evolution",ylab="dwell time (sec)",xlab="path")
    abline(h=c(25,75),lty=2)
  }
  
  timing = timing*path + sum(wait_vec)
  volume = round(I*12*0.1/1000*(X_right-X_left)/reso*path,3)
  if(return != 0){
    timing = timing *2
    volume = volume*2
  }
  # replace the parts
  step$gcode = gcode
  step$plot = plot_step
  step$info = c("for plate of 50*100 mm.\n","application on the left side\n","Same as SA_2\n",
                paste0("Volume used (µL): ",volume,"\n"),
                paste0("Estimated time: ",round(timing), " sec = ",round(timing/60,2)," min"))
  return(step)
}

## function eat table for OC_manager

eat_table_Deriv = function(step){
  # eat_table_Deriv function V01,21 february 2017
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
  dist_bottom = ceiling(table[table[,1] == "dist_bottom",2]/reso)
  dist_top = ceiling(table[table[,1] == "dist_top",2]/reso)
  dist_gauche = ceiling(table[table[,1] == "dist_gauche",2]/reso)
  band_length = ceiling(table[table[,1] == "band_length",2]/reso)
  gap = ceiling(table[table[,1] == "gap",2]/reso)
  nbr_band = table[table[,1] == "nbr_band",2]
  dist_gauche_saved = dist_gauche
  for(i in seq(nbr_band)){
    a[dist_gauche:(dist_gauche+band_length),dist_bottom:dist_top,] = 1 ## X/Y inverse, 
    dist_gauche = dist_gauche+band_length+gap
  }
  
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
  I = table[table[,1] == "I",2];L=table[table[,1] == "L",2];
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

eat_table_Deriv_2 = function(step){
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

eat_table_Deriv_3 = function(step){
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

eat_table_Deriv_vert = function(step){
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

eat_table_Deriv_single_nozzle = function(step){
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

eat_table_SA = function(step){
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


eat_table_SA_2 = function(step){
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

eat_table_SA_in_X = function(step){
  # eat_table_SA_in_X function V01,26 april 2017
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
                  paste0("G1 F",60*speed," ; set speed in mm per min for the movement")
  )
  end_gcode = c("G28 X0; home X axis",
                "G28 Y0; home Y axis",
                "M84     ; disable motors")
  ## previously function a_to_gcode_X_fix
  
  S = rep(0,12)
  for(i in seq(12)){if(i %in% as.numeric(nozzle)){S[i] = 1}};S = BinToDec(S)
  shift = round((1 - nozzle)*reso,3)
  
  ## begin gcode
  gcode = c(start_gcode,
            paste0("G1 Y",dist_bottom+shift," ; go in Y position") 
            
  )
  ## iterate
  for(k in seq(path)){
    for(band in seq(nrow(SA_table))){
      X_coord = round(seq(from = dist_gauche+(band-1)*(gap+band_length),by=reso,length.out = ceiling(band_length/reso)),3)# 25 added so user doesn't care
      # gcode = c(gcode,paste0("G1 X",dist_gauche+shift+(band-1)*(gap+band_length),"; go in Y position"))
      if(SA_table$Use[band]){
        I = SA_table$I[band]
        for(Repeat in seq(SA_table$Repeat[band])){
          for(i in X_coord){ # X loop, need modulo
            gcode = c(gcode,paste0("G1 X",i," ; go in position - path: ",k))
            gcode = c(gcode,"M400 ; Wait for current moves to finish ")
            gcode = c(gcode,paste0("M700 P0 I",I," L",L," S",S," ; Fire"))
          }
        }
      }
    }
    if(W != 0){gcode=c(gcode,paste0("G4 S",W,"; wait in seconds"))}
  }
  gcode = c(gcode,end_gcode)
  
  plot_step=function() {
    plot(c(1,100),c(1,100),type="n",xlim=c(0,100),ylim=c(100,0),xlab="X",ylab="Y",main="Origin in upper left corner")
    for(band in seq(nrow(SA_table))){
      if(SA_table$Use[band]){
        segments(y0 = dist_bottom,
                 x0 = dist_gauche+shift+(band-1)*(gap+band_length),
                 x1 = dist_gauche+shift+(band-1)*(gap+band_length)+band_length)
      }
    }
  }
  
  # replace the parts
  step$gcode = gcode
  step$plot = plot_step
  step$info = c("This method is for 10 by 10 plates in the multipurpose plate holde\nthe plate is store horizontally\nthe distance convention is made for the exterior of the plate\n",
                paste0("Band ",seq(nrow(SA_table)),": Volume used: ", SA_table$I*0.1*ceiling(band_length/reso)*SA_table$Repeat*path/1000," µL\n")
  )
  return(step)
}


eat_table_SA_grid= function(step){
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


eat_table_heating = function(step){
  # eat_table_heating function V011,24 february 2017
  # very simple anyway, home, start heating, and wait the needed time, then home again
  # extract the needed information
  table = step$table
  Temperature=table[table[,1] == "Temperature",2];Time=table[table[,1] == "Time",2]
  
  gcode = c("G28 X0; home X axis",
            "G28 Y0; home Y axis",
            paste0("M190 S",Temperature," ; set temperature, wait to reach, use M140 to set and go to the next one"),
            paste0("G4 s",Time*60," ; time wait in secondes"),
            "M190 S0 ; set temperature off",
            "G28 X0; home X axis",
            "G28 Y0; home Y axis"
  )
  
  plot_step=function() {
    plot(c(1),c(1),type="n",main="No plot for heating step")
  }
  
  # replace the parts
  step$gcode = gcode
  step$plot = plot_step
  step$info = "still not but incomming"
  return(step)
}

eat_table_Scan_dart = function(step){
  # eat_table_Scan_dart function V011,07 March 2017
  # very simple anyway, home, start heating, and wait the needed time, then home again
  # extract the needed information
  table = step$table
  nbr_band=table[table[,1] == "nbr_band",2];
  speed_travel=table[table[,1] == "speed_travel",2]
  speed_scan=table[table[,1] == "speed_scan",2]
  gap=table[table[,1] == "gap",2]
  dist_gauche=table[table[,1] == "dist_gauche",2]
  Y_start=table[table[,1] == "Y_start",2]
  Y_end=table[table[,1] == "Y_end",2]
  M42=table[table[,1] == "M42",2]
  
  gcode = c( ## begin Gcode
    "M106 S255; fan on, for the 12v of the end stops",
    "G28 X0; home X axis",
    "G28 Y0; home X axis",
    "G21 ; set units to millimeters",
    "G90 ; use absolute coordinates"
  )
  for(i in 0:(nbr_band-1)){
    gcode = c(gcode, ## fill gcode
            paste0("G1 F",60*speed_travel," ; set speed in mm per min for the travel movement"),
            "G1 X0; go in X0",
            "G1 Y0; go in Y0",
            paste0("G1 X",dist_gauche + i*gap," ; go in X band position"),
            paste0("G1 Y",Y_start," ; go in Y start"),
            if(as.logical(M42)){c("M42 P63 S1;set pin 63 to high","G4 P20;wait 20 ms","M42 P63 S0;set pin 63 to low")},
            paste0("G1 F",60*speed_scan," ; set speed in mm per min for the scan movement"),
            paste0("G1 Y",Y_end," ; go in Y end")
    )
  }
  gcode = c(gcode, ## end gcode
            "G28 X0; go in X0",
            "G28 Y0; go in Y0",
            "M84     ; disable motors"
  )
  
  plot_step=function() {
    plot(x=0,y=0,type="n",xlim=c(0,100),ylim=c(0,100),xlab="X",ylab="Y",sub = "Careful of X, Y and direction for first scans")
    ## add stuff on the plate
    for(i in 0:(nbr_band-1)){
      segments(x0=dist_gauche + i*gap,
               y0=Y_start,y1=Y_end)
    }
  }
  
  # replace the parts
  step$gcode = gcode
  step$plot = plot_step
  step$info = "Calcul from the middle of the band (ATS4 convention)\nBe carefull with X and Y inversion"
  return(step)
}

eat_table = list(
  LP = eat_table_LP,
  LP_2 = eat_table_LP_2,
  SA = eat_table_SA,
  SA_2 = eat_table_SA_2,
  SA_in_X = eat_table_SA_in_X,
  SA_grid = eat_table_SA_grid,
  Dev = eat_table_Dev,
  Dev_2 = eat_table_Dev_2,
  Dev_in_X = eat_table_Dev_in_X,
  Deriv = eat_table_Deriv,
  Deriv_2 = eat_table_Deriv_2,
  Deriv_3 = eat_table_Deriv_3,
  Deriv_single_nozzle = eat_table_Deriv_single_nozzle,
  Deriv_vert = eat_table_Deriv_vert,
  heating = eat_table_heating,
  Scan_dart = eat_table_Scan_dart
)