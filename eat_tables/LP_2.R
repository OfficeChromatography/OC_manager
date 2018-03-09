# eat_table_LP_2 = 
function(step){
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