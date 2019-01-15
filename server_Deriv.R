output$Deriv_control_1 = renderUI({
  validate(
    need(connect$board,"Please connect the board")
  )
  tagList(
    textInput("Deriv_file_name","file name","Deriv_file_name"),
    actionButton("Deriv_action","Launch Gcode"),
    uiOutput("Deriv_infoGcode")
  )
})
output$Deriv_options = renderTable({
  data = read.table("tables/Deriv_table.csv",header=T,sep=";")
  data$Value <- paste0("<input id='Deriv_",data$Value,"' class='shiny-bound-input' type='number'  value='",data$Default,"'>")
  data[,c(1,2)]
}, sanitize.text.function = function(x) x)
Deriv_bitmap_a = reactive({
  ## empty array
  inche = 25.4 # mm/inche
  dpi = 96
  reso = inche/dpi
  nozzle_X = 12;nozzle_Y = 1
  plate_X = 100;plate_Y=100
  path = input$Deriv_path
  X=floor(plate_X/reso/nozzle_X)*nozzle_X;Y=floor(plate_Y/reso/nozzle_Y)*nozzle_Y
  a = array(0,dim = c(X,Y,path))
  ## fill the array
  dist_bottom = ceiling(input$Deriv_dist_bottom/reso)
  dist_top = ceiling(input$Deriv_dist_top/reso)
  dist_gauche = ceiling(input$Deriv_dist_gauche/reso)
  band_length = ceiling(input$Deriv_band_length/reso)
  gap = ceiling(input$Deriv_gap/reso)
  dist_gauche_saved = dist_gauche
  for(i in seq(input$Deriv_nbr_band)){
    a[dist_gauche:(dist_gauche+band_length),dist_bottom:dist_top,] = 1
    dist_gauche = dist_gauche+band_length+gap
  }
  a
})
Deriv_bitmap_b = reactive({
  a_to_b(Deriv_bitmap_a())
})
observeEvent(input$Deriv_action,{
  # create the gcode
  Deriv_file = paste0("gcode/",format(Sys.time(),"%Y%m%d_%H:%M:%S"),input$Deriv_file_name,".gcode")
  Log = Deriv_file
  fileConn<-file(Deriv_file)
  writeLines(Deriv_gcode(), fileConn)
  close(fileConn)
  # put it in the log
  write(paste0(format(Sys.time(),"%Y%m%d_%H:%M:%S"),";","Deriv;",Deriv_file,";",Log,";",connect$Visa,";",input$Plate),file="log/log.txt",append = T)
  # send the gcode
  python.call("send_gcode",Deriv_file)
})
output$Deriv_infoGcode = renderUI({
  tagList(
    h6(paste0(paste0("Number of nozzles fired: ",sum(Deriv_bitmap_a())*input$Deriv_I))),
    h6(paste0(paste0("nozzles fired/mm2: ",sum(Deriv_bitmap_a())*input$Deriv_I/(input$Deriv_dist_top-input$Deriv_dist_bottom)/input$Deriv_band_length/input$Deriv_nbr_band))),
    h6(paste0(paste0("nozzles fired/dm2: ",sum(Deriv_bitmap_a())*input$Deriv_I/(input$Deriv_dist_top-input$Deriv_dist_bottom)/input$Deriv_band_length/input$Deriv_nbr_band*10000))),
    h6(paste0("Number of positions fired: ",sum(as.logical(Deriv_bitmap_b()))))
  )
  
})
output$Deriv_plot <- renderPlot({
  DLC::raster(1-apply(Deriv_bitmap_a(),c(1,2),mean),xaxs="i",yaxs="i")
  # plot(x=0,y=0,type="n",xlim=c(0,100),ylim=c(0,100),xlab="Y",ylab="X",sub = "note that the plate is reversed on the printer")
})
Deriv_gcode <- reactive({
  
  start_gcode = c("G28 X0; home X axis",
                  "G28 Y0; home Y axis",
                  "G21 ; set units to millimeters",
                  "G90 ; use absolute coordinates",
                  paste0("G1 F",60*input$Deriv_speed," ; set speed in mm per min for the movement")
  )
  end_gcode = c("G28 X0; home X axis",
                "G28 Y0; home Y axis",
                "M84     ; disable motors")
  
  b=Deriv_bitmap_b()
  
  b_to_gcode(b,start_gcode,end_gcode,input$Deriv_I)
})
output$Deriv_gcode <- renderDataTable({
  data.frame(gcode = Deriv_gcode())
},options = list(pageLength = 10))