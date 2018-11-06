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

testConnection  <- function(){
  if (ocDriver$is_connected()){
      print("connected")
      connect$board=TRUE
  } else {
      print("try again")
  }
}

throwError  <- function(msg){
    shinyalert(title = "An Error has occurred",text = "No shudown, bad user",type="error")
}

setupEventHandler  <- function(input){
 observeEvent(input$Shutdown,{
    if(getwd() == "/home/pi/OC_manager"){
      system("sudo shutdown now")
    }else{
      throwError("No shutdown, bad user")
    }
  })
  observeEvent(input$Reboot,{
    if(getwd() == "/home/pi/OC_manager"){
      system("sudo reboot")
    }else{
      throwError("No reboot, bad user")
    }
  })

observeEvent(input$Serial_port_connect,{
     if(nchar(input$Serial_port) == 0){
         throwError("No board selected")
     }else{
         print("Connecting")
         ocDriver$connect()

         if (ocDriver$is_connected()){
                                        # create the test gcode
             print("Connected")
         } else {
             print("try again")
         }
     }
  })

observeEvent(input$Serial_port_disconnect,{

      ocDriver$disconnect()

    if (!ocDriver$is_connected()){
    # create the test gcode
      print("disconnected")
    } else {
        print("try again")
    }
  })
}



shinyServer(function(input, output,session) {

  source("./OCDriverLoader.R", local = F)
  source("server_visu.R",local = T)
  source("server_Fine_control.R",local = T)
  source("server_Method.R",local = T)

  # connect with the hardware and use printcore to control
  connect = reactiveValues(board = board)y

  testConnection()

  session$onSessionEnded(function() {
    ocDriver$disconnect() ## py
  })

  setupEventHandler(input)

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



  TempInvalidate <- reactiveTimer(2000)

  output$Log = renderDataTable({
    input$Log_refresh
    read.table("log/log.txt",header = T,sep = ";")
  })

 #close function
    session$onSessionEnded(function() {
        stopApp()
})


})


