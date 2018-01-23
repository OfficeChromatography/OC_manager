
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
# library(rPython)
library(reticulate) #devtools::install_github("rhandsontable","jrowen")
library(DLC)
library(serial)#for port detection in windows
library(rhandsontable)
library(parallel)


f.read.image = function(source,height=NULL,Normalize=F,ls.format=F){
  ls <- list()
  for(i in source){
    try(data<-readTIFF(i,native=F)) # we could use the magic number instead of try here
    try(data<-readJPEG(source=i,native=F))
    try(data<-readPNG(source=i,native=F))
    if(!is.null(height)){
      data <- redim.array(data,height)
    }
    if(Normalize == T){data <- data %>% normalize}
    ls[[i]]<- data
  }
  if(ls.format == F){
    data <- abind(ls,along=2)
  }else{
    data <- ls
  }
  return(data)
}

source("config.R")

shinyServer(function(input, output,session) {
  
  connect = reactiveValues(login = login, board = board,Visa = NULL)
  # connect = reactiveValues(login = login, board = board,Visa = "admin")``
  source("functions.R")
  source("server_visu.R",local = T)
  source("server_TLC_MS.R",local = T)
  source("server_ink_test.R",local = T)
  # python.load("setup.py")
  # main <- import_main()
  main = py_run_file("setup.py")
  
  session$onSessionEnded(function() {
    # if(connect$board){
      # python.call("close_connections") ## py
    # py_call("close_connections") ## py
    main$close_connections() ## py
      # put it in the log
      # write(paste0(format(Sys.time(),"%Y%m%d_%H:%M:%S"),";","Connection;",NA,";","Board disconnection",";",connect$Visa,";",input$Plate),file="log/log.txt",append = T)
      
    # }
    # if(connect$login){
      # put it in the log
      # write(paste0(format(Sys.time(),"%Y%m%d_%H:%M:%S"),";","Connection;",NA,";","Sign out",";",connect$Visa,";",input$Plate),file="log/log.txt",append = T)
    # }
  })
  
  output$Login = renderUI({
    if(!connect$login){
      tagList(
        textInput("Visa","Visa","admin"),
        passwordInput("parola","password",value = ""),
        actionButton("Login_connect","connect")
      )
    }else{
      tagList(
        h6(paste0(connect$Visa," connected")),
        actionButton("Login_disconnect","disconnect")
      )
    }
  })
  

  observeEvent(input$Shutdown,{
    system("sudo shutdown now")
  })
  observeEvent(input$Reboot,{
    system("sudo reboot")
  })
  observeEvent(input$Login_connect,{
    t = read.csv2("logins.csv")
    if(t[t$Visa == input$Visa,2] == input$parola){
      connect$login = T
      connect$Visa = input$Visa
      # put it in the log
      write(paste0(format(Sys.time(),"%Y%m%d_%H:%M:%S"),";","Connection;",NA,";","Sign in",";",connect$Visa,";",input$Plate),file="log/log.txt",append = T)
    }else{
      # put it in the log
      write(paste0(format(Sys.time(),"%Y%m%d_%H:%M:%S"),";","Connection;",NA,";","Connection attempt",";",input$Visa,";",input$Plate),file="log/log.txt",append = T)
      
    }
  })
  observeEvent(input$Login_disconnect,{
    connect$login = F
    # put it in the log
    write(paste0(format(Sys.time(),"%Y%m%d_%H:%M:%S"),";","Connection;",NA,";","Sign out",";",connect$Visa,";",input$Plate),file="log/log.txt",append = T)
    
    if(!board){ ## must check if not in development, cf config.R file
      if(connect$board){
        # python.call("close_connections") ## py
        py_call("close_connections") ## py
        # put it in the log
        write(paste0(format(Sys.time(),"%Y%m%d_%H:%M:%S"),";","Connection;",NA,";","Board disconnection",";",connect$Visa,";",input$Plate),file="log/log.txt",append = T)
        connect$board = F
      }
    }
  })
  
  output$Serial_port = renderUI({
    input$Serial_port_refresh
    if(input$Serial_windows){
      selectizeInput("Serial_port","select Serial port",choices = listPorts())
    }else{
      selectizeInput("Serial_port","select Serial port",choices = dir("/dev/",pattern = "ACM",full.names = T))
    }
  })
  output$Serial_port_connect = renderUI({
    validate(
      need(connect$login,"Please login")
    )
    if(!connect$board){
      actionButton("Serial_port_connect","connect the board")
    }else{
      actionButton("Serial_port_disconnect","disconnect the board")
    }
  })
  observeEvent(input$Serial_port_connect,{
    # python.call("connect_board",input$Serial_port) ## py
    # py_call("connect_board",as.character(input$Serial_port)) ## py
    main$connect_board(input$Serial_port) ## py
    # put it in the log
    write(paste0(format(Sys.time(),"%Y%m%d_%H:%M:%S"),";","Connection;",NA,";","Board connection",";",connect$Visa,";",input$Plate),file="log/log.txt",append = T)
    connect$board = T
  })
  observeEvent(input$Serial_port_disconnect,{
    # python.call("close_connections") ## py
    # py_call("close_connections") ## py
    main$close_connections() ## py
    # put it in the log
    write(paste0(format(Sys.time(),"%Y%m%d_%H:%M:%S"),";","Connection;",NA,";","Board disconnection",";",connect$Visa,";",input$Plate),file="log/log.txt",append = T)
    connect$board = F
  })
  observeEvent(input$Serial_port_disconnect_bis,{
    # python.call("close_connections") ## py
    # py_call("close_connections") ## py
    main$close_connections() ## py
    connect$board = F
  })
  
  TempInvalidate <- reactiveTimer(2000)

  
  source("server_SA.R",local = T)
  
  source("server_Dev.R",local = T)
  
  source("server_Deriv.R",local = T)

  source("server_Method.R",local = T)  
  

  
  output$Log = renderDataTable({
    input$Log_refresh
    read.table("log/log.txt",header = T,sep = ";")
  })
  

  output$About_table_inventory = renderTable({
    read.csv("tables/inventory.csv",header=T,sep=";")
  })
  
  
})
