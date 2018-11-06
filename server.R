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
    connected = ocDriver$is_connected()
    if (connected){                                        # create the test gcode
        print("Connected")
    }
    else {
        print("try again")
   }
}


shinyServer(function(input, output,session) {

  source("./OCDriverLoader.R", local = F)
  source("server_visu.R",local = T)
  source("server_Fine_control.R",local = T)
  source("server_Method.R",local = T)

  # connect with the hardware and use printcore to control
  testConnection()

  observeEvent(input$Serial_port_connect,{
     if(nchar(input$Serial_port) == 0){
         throwError("No board selected")
     }else{
         print("Connecting")
         ocDriver$connect()
         testConnection()
     }
  })

    observeEvent(input$Serial_port_disconnect,{
        ocDriver$disconnect()
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
    if(!ocDriver$is_connected()){
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

  session$onSessionEnded(function() {
      ocDriver$disconnect()
      stopApp()
  })

})


