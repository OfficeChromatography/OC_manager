
fineControlDriver = ocDriver$get_fine_control_driver()

observeEvent(input$test_ink_cmd_button,{ 
    fineControlDriver$customCommand(toupper(input$test_ink_cmd))

})

observeEvent(input$xleft,{
    fineControlDriver$goXLeft()
})
observeEvent(input$xhome,{
    fineControlDriver$goHome()
})

observeEvent(input$xright,{
        fineControlDriver$goXRight()
})

observeEvent(input$yup,{
        fineControlDriver$goYUp()
})

observeEvent(input$yhome,{
        fineControlDriver$goHome()
})

observeEvent(input$ydown,{
        fineControlDriver$goYDown()
})

observeEvent(input$stop,{
        fineControlDriver$stop()
})


#---------------------------------------------------------------------------------------
#Inkjet
#-------
                                        # TODO REFACTOR
writeFile  <- function(filePath, input){
    fileConn<-file(filePath)
    writeLines(input, fileConn)
    close(fileConn)
}

createNozzleTestGCODE  <- function(input){
    inkBias <- input$test_ink_n_bis
    testInkL  <- input$test_ink_L
    gcode =c("G91",paste0("M700 P0 I",inkBias, " L",testInkL," S",4095))
    for(i in seq(12)){
      S=rep(0,12);S[i] = 1;S = S=sum(2^(which(S== 1)-1))
      for(j in seq(10)){gcode = c(gcode,paste0("G1 X",0.25),"M400",paste0("M700 P0 I",inkBias," L",testInkL," S",S))}
    }
    gcode = c(gcode,paste0("G1 X",2),"M400",paste0("M700 P0 I",inkBias," L",testInkL," S",4095))
    gcode = c(gcode,"G90","M84")
    return (gcode)
}

observeEvent(input$test_ink_nozzle_test,{
    gcode = createNozzleTestGCODE(input)
    writeFile("gcode/test_ink.gcode", gcode)
    ocDriver$send_light_gcode_from_file(test_ink_file)

})

observeEvent(input$test_ink_action,{
    test_ink_file = "gcode/test_ink.gcode"
    Log = test_ink_file
    writeFile(test_ink_file, test_ink_gcode())
    # put it in the log
    write(paste0(format(Sys.time(),"%Y%m%d_%H:%M:%S"),";","test_ink;",test_ink_file,";",Log,";",connect$Visa,";",input$Plate),file="log/log.txt",append = T)
    ocDriver$send_light_gcode_from_file(test_ink_file)
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
    ocDriver$send_light_gcode_from_file(input$test_ink_gcode_file$datapath)
})

#----------------------------------------------------------------------------------------
#Docu

observeEvent(input$test_ink_visu_position,{
      ocDriver$send_light_gcode_from_file("gcode/Visu_position.gcode")
  })

observeEvent(input$test_ink_ring_on,{
      system("sudo python /home/pi/rpi_ws281x/python/examples/led-on.py")
})
observeEvent(input$test_ink_ring_off,{
    system("sudo python /home/pi/rpi_ws281x/python/examples/led-off.py")
})






