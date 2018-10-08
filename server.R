# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
# library(rPython)
library(reticulate)
#library(DLC)
library(serial)#for port detection in windows
library(rhandsontable)#devtools::install_github("rhandsontable","jrowen")
library(parallel)
library(shinyBS)
library(shinyalert)



shinyServer(function(input, output,session) {
  source("config.R")
  source("server_visu.R",local = T)
  source("server_Fine_control.R",local = T)
  source("server_Method.R",local = T)  
  
# connect with the hardware and use printcore to control
  connect = reactiveValues(board = board)
  gcode_sender<-py_run_file("gcode_sender.py")
  source_python("printrun/printcore.py")
  printer=printcore()
  printer$connect("/dev//ttyACM0",115200)
  printer$listen_until_online()
  if (printer$online){
    # create the test gcode
      print("Connected")
      connect$board=TRUE
      }
  else {print("try again")}
  

  session$onSessionEnded(function() {
    printer$disconnect() ## py
  })

  observeEvent(input$Shutdown,{
    if(getwd() == "/home/pi/OC_manager"){
      system("sudo shutdown now")
    }else{
      shinyalert(title = "stupid user",text = "No shudown, bad user",type="error")
    }
  })
  observeEvent(input$Reboot,{
    if(getwd() == "/home/pi/OC_manager"){
      system("sudo reboot")
    }else{
      shinyalert(title = "stupid user",text = "No reboot, bad user",type="error")
    }
  })
 
  output$Serial_portUI = renderUI({
    input$Serial_port_refresh
    if(input$Serial_windows){
      selectizeInput("Serial_port","Select serial port",choices = listPorts())
    }else{
      selectizeInput("Serial_port","Select serial port",choices = dir("/dev/",pattern = "ACM",full.names = T))
    }
  })
  output$Serial_port_connectUI = renderUI({
    if(!connect$board){
      actionButton("Serial_port_connect","Connect the board")
    }else{
      actionButton("Serial_port_disconnect","Disconnect the board")
    }
  })
  observeEvent(input$Serial_port_connect,{
    if(nchar(input$Serial_port) == 0){
      shinyalert(title = "stupid user",text = "No board selected",type="error")
    }else{
      print("Connecting")
      printer$connect(input$Serial_port,115200)## py
      printer$listen_until_online()
      if (printer$online){
    # create the test gcode
      print("Connected")
      connect$board=TRUE
      }
      else {print("try again")}
    }
  })
  
  observeEvent(input$Serial_port_disconnect,{
    printer$disconnect()
    if (!printer$online){
    # create the test gcode
      connect$board=FALSE
      print("disconnected")
    }
      else {print("try again")}
  })

  
  TempInvalidate <- reactiveTimer(2000)

  output$Log = renderDataTable({
    input$Log_refresh
    read.table("log/log.txt",header = T,sep = ";")
  })
  
})
