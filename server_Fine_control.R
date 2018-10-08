# todo: this file should only contain ui description and event handler bindings#
# todo: extract printer logic into new software layer

# GUI
output$ink_test_control_1 = renderUI({
  tagList(
  fluidPage(
  column(6, 
      fluidRow(
      box(title = "Motor Control", width = "50 %", heigth ="50 %",solidHeader = TRUE,status = "primary",
      fluidRow(
      column(6,
      fluidRow(
          column(2,"X :"),
          column(2,offset=1,actionButton("xleft","",icon=icon("arrow-left"))),
          column(2,actionButton("xhome","",icon=icon("home"))),
          column(2,actionButton("xright","",icon=icon("arrow-right")))
           ),

      fluidRow(
          column(2,"Y :"),
          column(2,offset=1,actionButton("yup","",icon=icon("arrow-up"))),
          column(2,actionButton("yhome","",icon=icon("home"))),
          column(2,actionButton("ydown","",icon=icon("arrow-down")))
           )),

      column(4,
           actionButton("stop","Disable Motors")
           )),
      fluidRow(
        column(8,
            textInput("test_ink_cmd","Command","G1 X10", width = "100%"),
           actionButton("test_ink_cmd_button","Launch GCODE")
          )
        )
      )),
     fluidRow( 
     box(title = "Gcode upload", width = "50 %", heigth ="50 %", solidHeader = TRUE,status = "primary",
                    fileInput("test_ink_gcode_file","Upload a GCODE file"),
                    actionButton("test_ink_gcode_file_action","Launch the GCODE file")
       )),
     fluidRow(
     box(title = "Documentation", width = "50 %", heigth ="50 %", solidHeader = TRUE,status = "primary",
                    actionButton("test_ink_visu_position","Go in position"),
                    actionButton("test_ink_ring_on","ring on"),
                    actionButton("test_ink_ring_off","ring off")
       ))
     
  ),
  column(6,
         box(title = "Inkjet", width = "50 %", heigth ="50 %", solidHeader = TRUE,status = "primary",
           numericInput("test_ink_n","Number of fire (repetition)",10),
           numericInput("test_ink_n_bis","Number of fire bis (I)",2),
           numericInput("test_ink_L","Pulse length",5),
           checkboxGroupInput("test_ink_S","Nozzles to fire",choices = seq(12),inline = T,selected = seq(12)),
           # numericInput("test_ink_S","S",4095),
           actionButton("test_ink_action",label = "Fire selected nozzles"),
           actionButton("test_ink_nozzle_test",label = "Nozzle testing process")
    )
  )
  )
  )
  })
#---------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------
#function
#---------
## motor control
# e.g.
# printerSendTestInc(input) {
#   printer$send(toupper(input$test_ink_cmd))
#   printer$Print()
# }
# restEndpointTestInk(cmd) {
#   printerSendTestInc(cmd)
#   
# }

observeEvent(input$test_ink_cmd_button,{ # event handler
  # should call our new printer core library
  # printerSendTestInc(String) : steuert
	printer$send(toupper(input$test_ink_cmd))
	printer$Print()
})

observeEvent(input$xleft,{
	printer$send("G91\nG1 X-5")
	printer$Print()
})

observeEvent(input$xhome,{
	printer$send("G28 X0\nG90")
	printer$Print()
})

observeEvent(input$xright,{
	printer$send("G91\nG1 X5")
	printer$Print()
})

observeEvent(input$yup,{
    	printer$send("G91\nG1 Y5")
    	printer$Print()
})

observeEvent(input$yhome,{
    	printer$send("G28 Y0\nG90")
    	printer$Print()
})

observeEvent(input$ydown,{
	printer$send("G91\nG1 Y-5")
        printer$Print()
})

observeEvent(input$stop,{
	printer$send("M18")
        printer$Print()
})


#---------------------------------------------------------------------------------------
#Inkjet
#-------

observeEvent(input$test_ink_nozzle_test,{
    gcode = c("G91",paste0("M700 P0 I",input$test_ink_n_bis," L",input$test_ink_L," S",4095))
    for(i in seq(12)){
      S=rep(0,12);S[i] = 1;S = S=sum(2^(which(S== 1)-1))
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
    gcode_sender$send_gcode(test_ink_file,printer)
})

observeEvent(input$test_ink_action,{
    test_ink_file = paste0("gcode/","test_ink",".gcode")
    Log = test_ink_file
    fileConn<-file(test_ink_file)
    writeLines(test_ink_gcode(), fileConn)
    close(fileConn)
    # put it in the log
    write(paste0(format(Sys.time(),"%Y%m%d_%H:%M:%S"),";","test_ink;",test_ink_file,";",Log,";",connect$Visa,";",input$Plate),file="log/log.txt",append = T)
    # send the gcode
    gcode_sender$send_gcode(test_ink_file,printer)
})
test_ink_gcode <- reactive({
  S=rep(0,12)
  for(i in seq(12)){if(i %in% as.numeric(input$test_ink_S)){S[i] = 1}};S = S=sum(2^(which(S== 1)-1))
  rep(paste0("M700 P0 I",input$test_ink_n_bis," L",input$test_ink_L," S",S),input$test_ink_n)
})

#----------------------------------------------------------------------------------------
#Gcode



observeEvent(input$test_ink_gcode_file_action,{
 # send the gcode
 gcode_sender$send_gcode(input$test_ink_gcode_file$datapath, printer)
})

#----------------------------------------------------------------------------------------
#Docu

observeEvent(input$test_ink_visu_position,{
      gcode_sender$send_gcode("gcode/Visu_position.gcode")
  })

observeEvent(input$test_ink_ring_on,{
      system("sudo python /home/pi/rpi_ws281x/python/examples/led-on.py")
})
observeEvent(input$test_ink_ring_off,{
    system("sudo python /home/pi/rpi_ws281x/python/examples/led-off.py")
})






