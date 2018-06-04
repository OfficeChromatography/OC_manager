## server_ink_test.R

output$ink_test_control_1 = renderUI({
  tagList(
    column(3,
           h4("General"),
           textInput("test_ink_cmd","Command","G1 X10"),
           actionButton("test_ink_cmd_button","Launch GCODE"),
           actionButton("test_ink_G28_X0","Home X"),
           actionButton("test_ink_G28_Y0","Home Y"),
           actionButton("test_ink_G28_Z0","Home Z"),
           actionButton("test_ink_M84","Disable Motors"),
           # uiOutput("temp_1"),
           actionButton("test_ink_LED","LED gcode in pin 63 (for testing only)"),
           actionButton("test_ink_LED_stop","Stop_LED (for testing only)")
    ),
    column(3,
           h4("Inkjet"),
           numericInput("test_ink_n","Number of fire (repetition)",10),
           numericInput("test_ink_n_bis","Number of fire bis (I)",2),
           numericInput("test_ink_L","Pulse length",5),
           checkboxGroupInput("test_ink_S","Nozzles to fire",choices = seq(12),inline = T,selected = seq(12)),
           # numericInput("test_ink_S","S",4095),
           actionButton("test_ink_action",label = "Fire selected nozzles"),
           actionButton("test_ink_nozzle_test",label = "Nozzle testing process")
    ),
    
    column(3,
           h4("Layer printing"),
           actionButton("test_ink_extrude_1mm","Extrude 1 mm"),
           actionButton("test_ink_extrude_5mm","Extrude 5 mm"),
           actionButton("test_ink_retract_5mm","Retract 5 mm"),
           numericInput("test_ink_bed_temp","Bed temperature (Prusa only)",105),
           actionButton("test_ink_bed_set","Set bed temperature")
    ),
    column(3,
           p("For testing only"),
           plotOutput("test_ink_plot",click="test_ink_plot_click")
    ),
    column(3,
           h4("Gcode upload"),
           fileInput("test_ink_gcode_file","Upload a GCODE file"),
           actionButton("test_ink_gcode_file_action","Launch the GCODE file")
    ),
    column(3,
           h4("Documentation"),
           actionButton("test_ink_visu_position","Go in position"),
           actionButton("test_ink_red","Red light"),
           actionButton("test_ink_green","Green light"),
           actionButton("test_ink_blue","Blue light"),
           actionButton("test_ink_white","White light"),
           actionButton("test_ink_254","254 nm light"),
           actionButton("test_ink_light_off","Turn light off")#,
           # actionButton("test_ink_ring_on","ring on"),
           # actionButton("test_ink_ring_off","ring off")
    )
  )
})

observeEvent(input$test_ink_visu_position,{
  if(connect$board){
    main$send_gcode("gcode/Visu_position.gcode")
  }else{
    shinyalert(title = "Error",text = "Board not connected",type="error",closeOnClickOutside = T, showCancelButton = F)
  }
})
observeEvent(input$test_ink_red,{
  if(connect$board){
    main$send_gcode("gcode/Red.gcode")
  }else{
    shinyalert(title = "Error",text = "Board not connected",type="error",closeOnClickOutside = T, showCancelButton = F)
  }
})
observeEvent(input$test_ink_green,{
  if(connect$board){
    main$send_gcode("gcode/Green.gcode")
  }else{
    shinyalert(title = "Error",text = "Board not connected",type="error",closeOnClickOutside = T, showCancelButton = F)
  }
})
observeEvent(input$test_ink_blue,{
  if(connect$board){
    main$send_gcode("gcode/Blue.gcode")
  }else{
    shinyalert(title = "Error",text = "Board not connected",type="error",closeOnClickOutside = T, showCancelButton = F)
  }
})
observeEvent(input$test_ink_white,{
  if(connect$board){
    main$send_gcode("gcode/White.gcode")
  }else{
    shinyalert(title = "Error",text = "Board not connected",type="error",closeOnClickOutside = T, showCancelButton = F)
  }
})
observeEvent(input$test_ink_254,{
  if(connect$board){
    main$send_gcode("gcode/254 nm.gcode")
  }else{
    shinyalert(title = "Error",text = "Board not connected",type="error",closeOnClickOutside = T, showCancelButton = F)
  }
})
observeEvent(input$test_ink_light_off,{
  if(connect$board){
    main$send_gcode("gcode/light_off.gcode")
  }else{
    shinyalert(title = "Error",text = "Board not connected",type="error",closeOnClickOutside = T, showCancelButton = F)
  }
})

observeEvent(input$test_ink_gcode_file_action,{
  if(connect$board){
    main$send_gcode(input$test_ink_gcode_file$datapath)
  }else{
    shinyalert(title = "Error",text = "Board not connected",type="error",closeOnClickOutside = T, showCancelButton = F)
  }
})

test_TempInvalidate <- reactiveTimer(2000)
output$temp_1 = renderUI({
  validate(
    need(connect$board,"Please connect the board")
  )
  # test_TempInvalidate()
  # full = python.call("get_temp")
  # full = gsub(pattern = "ok T:0.0 /0.0 B:",x = full,replacement = "Bed temp: ")
  # full = gsub(pattern = "@:0 B@:0",x = full,replacement = "°C")
  tagList(
    # h6(full),
    h6("M104 S90; set temp to 90 degree celsius")
  )
})

observeEvent(input$test_ink_nozzle_test,{
  if(connect$board){
    gcode = c("G91",paste0("M700 P0 I",input$test_ink_n_bis," L",input$test_ink_L," S",4095))
    for(i in seq(12)){
      S=rep(0,12);S[i] = 1;S = BinToDec(S)
      for(j in seq(10)){gcode = c(gcode,paste0("G1 X",0.25),"M400",paste0("M700 P0 I",input$test_ink_n_bis," L",input$test_ink_L," S",S))}
    }
    gcode = c(gcode,paste0("G1 X",2),"M400",paste0("M700 P0 I",input$test_ink_n_bis," L",input$test_ink_L," S",4095))
    gcode = c(gcode,"G90","M84")
    test_ink_file = paste0("gcode/","test_ink",".gcode")
    Log = test_ink_file
    fileConn<-file(test_ink_file)
    writeLines(gcode, fileConn)
    close(fileConn)
    # send the gcode
    main$send_gcode(test_ink_file)
  }else{
    shinyalert(title = "Error",text = "Board not connected",type="error",closeOnClickOutside = T, showCancelButton = F)
  }
})
observeEvent(input$test_ink_action,{
  if(connect$board){
    # create the gcode
    # test_ink_file = paste0("gcode/",format(Sys.time(),"%Y%m%d_%H:%M:%S"),"test_ink",".gcode")
    test_ink_file = paste0("gcode/","test_ink",".gcode")
    Log = test_ink_file
    fileConn<-file(test_ink_file)
    writeLines(test_ink_gcode(), fileConn)
    close(fileConn)
    # put it in the log
    write(paste0(format(Sys.time(),"%Y%m%d_%H:%M:%S"),";","test_ink;",test_ink_file,";",Log,";",connect$Visa,";",input$Plate),file="log/log.txt",append = T)
    # send the gcode
    main$send_gcode(test_ink_file)
  }else{
    shinyalert(title = "Error",text = "Board not connected",type="error",closeOnClickOutside = T, showCancelButton = F)
  }
})
test_ink_gcode <- reactive({
  # paste0("M700 P0 I",input$test_ink_n_bis," S",input$test_ink_S)
  # rep(paste0("M700 P0 S",input$test_ink_S),input$test_ink_n)
  S=rep(0,12)
  for(i in seq(12)){if(i %in% as.numeric(input$test_ink_S)){S[i] = 1}};S = BinToDec(S)
  rep(paste0("M700 P0 I",input$test_ink_n_bis," L",input$test_ink_L," S",S),input$test_ink_n)
})
observeEvent(input$test_ink_cmd_button,{
  if(connect$board){
    # create the gcode
    test_ink_file = "gcode/test_ink_cmd.gcode"
    Log = test_ink_file
    fileConn<-file(test_ink_file)
    writeLines(input$test_ink_cmd, fileConn)
    close(fileConn)  # send the gcode
    main$send_gcode(test_ink_file)
  }else{
    shinyalert(title = "Error",text = "Board not connected",type="error",closeOnClickOutside = T, showCancelButton = F)
  }
})
output$test_ink_plot = renderPlot({
  x = c(0,130)
  y = c(80,0)
  plot(x,y,type="n",xlim=x,ylim=y,main="Origin in Upper left corner",xaxs="i",yaxs="i",
       xlab="X",ylab="Y")
  abline(h=seq(from=0,to=200,by = 10),v=seq(from=0,to=200,by = 10))
})
observeEvent(input$test_ink_plot_click,{
  if(connect$board){
    if(!is.null(input$test_ink_plot_click)){
      truc = paste0("G1 X",round(input$test_ink_plot_click$x,4)," Y",round(input$test_ink_plot_click$y,4))
      print(truc)
      # create the gcode
      test_ink_file = "gcode/test_ink_plot.gcode"
      fileConn<-file(test_ink_file)
      writeLines(truc, fileConn)
      close(fileConn)
      # send the gcode
      main$send_gcode(test_ink_file)
    }
  }else{
    shinyalert(title = "Error",text = "Board not connected",type="error",closeOnClickOutside = T, showCancelButton = F)
  }
})
observeEvent(input$test_ink_LED,{
  if(connect$board){
    main$send_gcode("gcode/LED.gcode")
    # py_run_file("send_gcode.py")
  }else{
    shinyalert(title = "Error",text = "Board not connected",type="error",closeOnClickOutside = T, showCancelButton = F)
  }
})
observeEvent(input$test_ink_LED_stop,{
  main$cancelprint() ## py
  # main$cancelprint()
})
# observeEvent(input$test_ink_LED_stop,{
#   validate(need(!input$Serial_windows,"not on windows"))
#   if(!is.null(rv$id$pid)){
#     tools::pskill(rv$id$pid)
#     rv$id <- list()
#   }
# })

# observeEvent(input$test_ink_ring_on,{
#   # if(connect$board){
#     # main$send_gcode("gcode/LED.gcode")
#     main$colorWipe(255L,0)
#   # }else{
#   #   shinyalert(title = "Error",text = "Board not connected",type="error",closeOnClickOutside = T, showCancelButton = F)
#   # }
# })
# observeEvent(input$test_ink_ring_off,{
#   # if(connect$board){
#     # main$send_gcode("gcode/LED.gcode")
#     main$colorWipe(0L,0)
#   # }else{
#   #   shinyalert(title = "Error",text = "Board not connected",type="error",closeOnClickOutside = T, showCancelButton = F)
#   # }
# })

observeEvent(input$test_ink_G28_X0,{
  if(connect$board){
  # create the gcode
  test_ink_file = "gcode/test_ink_cmd.gcode"
  Log = test_ink_file
  fileConn<-file(test_ink_file)
  writeLines("G28 X0", fileConn)
  close(fileConn)  # send the gcode
  main$send_gcode(test_ink_file)
  }else{
    shinyalert(title = "Error",text = "Board not connected",type="error",closeOnClickOutside = T, showCancelButton = F)
  }
})
observeEvent(input$test_ink_G28_Y0,{
  if(connect$board){
  # create the gcode
  test_ink_file = "gcode/test_ink_cmd.gcode"
  Log = test_ink_file
  fileConn<-file(test_ink_file)
  writeLines("G28 Y0", fileConn)
  close(fileConn)  # send the gcode
  main$send_gcode(test_ink_file)
  }else{
    shinyalert(title = "Error",text = "Board not connected",type="error",closeOnClickOutside = T, showCancelButton = F)
  }
})
observeEvent(input$test_ink_G28_Z0,{
  if(connect$board){
  # create the gcode
  test_ink_file = "gcode/test_ink_cmd.gcode"
  Log = test_ink_file
  fileConn<-file(test_ink_file)
  writeLines("G28 Z0", fileConn)
  close(fileConn)  # send the gcode
  main$send_gcode(test_ink_file)
  }else{
    shinyalert(title = "Error",text = "Board not connected",type="error",closeOnClickOutside = T, showCancelButton = F)
  }
})

observeEvent(input$test_ink_M84,{
  if(connect$board){
  # create the gcode
  test_ink_file = "gcode/test_ink_cmd.gcode"
  Log = test_ink_file
  fileConn<-file(test_ink_file)
  writeLines("M84", fileConn)
  close(fileConn)  # send the gcode
  main$send_gcode(test_ink_file)
  }else{
    shinyalert(title = "Error",text = "Board not connected",type="error",closeOnClickOutside = T, showCancelButton = F)
  }
})
observeEvent(input$test_ink_extrude_1mm,{
  if(connect$board){
  # create the gcode
  test_ink_file = "gcode/test_ink_cmd.gcode"
  Log = test_ink_file
  fileConn<-file(test_ink_file)
  writeLines(c("G92 E0","G1 E1"), fileConn)
  close(fileConn)  # send the gcode
  main$send_gcode(test_ink_file)
  }else{
    shinyalert(title = "Error",text = "Board not connected",type="error",closeOnClickOutside = T, showCancelButton = F)
  }
})
observeEvent(input$test_ink_extrude_5mm,{
  if(connect$board){
  # create the gcode
  test_ink_file = "gcode/test_ink_cmd.gcode"
  Log = test_ink_file
  fileConn<-file(test_ink_file)
  writeLines(c("G92 E0","G1 E5"), fileConn)
  close(fileConn)  # send the gcode
  main$send_gcode(test_ink_file)
  }else{
    shinyalert(title = "Error",text = "Board not connected",type="error",closeOnClickOutside = T, showCancelButton = F)
  }
})
observeEvent(input$test_ink_retract_5mm,{
  if(connect$board){
  # create the gcode
  test_ink_file = "gcode/test_ink_cmd.gcode"
  Log = test_ink_file
  fileConn<-file(test_ink_file)
  writeLines(c("G92 E0","G1 E-5"), fileConn)
  close(fileConn)  # send the gcode
  main$send_gcode(test_ink_file)
  }else{
    shinyalert(title = "Error",text = "Board not connected",type="error",closeOnClickOutside = T, showCancelButton = F)
  }
})
observeEvent(input$test_ink_bed_set,{
  if(connect$board){
  # create the gcode
  test_ink_file = "gcode/test_ink_cmd.gcode"
  Log = test_ink_file
  fileConn<-file(test_ink_file)
  writeLines(paste0("M140 S",input$test_ink_bed_temp), fileConn)
  close(fileConn)  # send the gcode
  main$send_gcode(test_ink_file)
  }else{
    shinyalert(title = "Error",text = "Board not connected",type="error",closeOnClickOutside = T, showCancelButton = F)
  }
})