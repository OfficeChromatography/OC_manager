
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
# library(rPython)
library(reticulate)
library(DLC)
library(serial)#for port detection in windows
library(rhandsontable)#devtools::install_github("rhandsontable","jrowen")
library(parallel)
library(shinyBS)




shinyServer(function(input, output,session) {
  source("config.R")
  login = T ## change to F to enable login, see the login.csv file to add users
  connect = reactiveValues(login = login, board = board,Visa = NULL)
  # connect = reactiveValues(login = login, board = board,Visa = "admin")
  source("functions.R")
  source("server_visu.R",local = T)
  source("server_TLC_MS.R",local = T)
  source("server_ink_test.R",local = T)
  

  # main = py_run_file("setup_old.py")
  main = py_run_file("setup.py")
  # python.load("setup.py")
  # python.load("setup_old.py")
  
  session$onSessionEnded(function() {
    main$close_connections() ## py
    # python.call("close_connections") ## py
    # stopApp()
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
        actionButton("Login_disconnect","disconnect")#,
        # actionButton("Login_options","Manage users",icon = icon("edit")),
        # bsModal("Login_Modal", "Login_options", "Login_options", size = "small",
        #   if(connect$Visa == "admin"){
        #     textInput("Visa","Visa","admin"),
        #     passwordInput("parola","password",value = ""),
        #     actionButton("Login_connect","connect")
        #   }else{
        #     p("Only admin can change password and add users")
        #   }
        # )
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
    load("login.Rdata")
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
        main$close_connections()
        # put it in the log
        write(paste0(format(Sys.time(),"%Y%m%d_%H:%M:%S"),";","Connection;",NA,";","Board disconnection",";",connect$Visa,";",input$Plate),file="log/log.txt",append = T)
        connect$board = F
      }
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
    validate(
      need(connect$login,"Please login")
    )
    if(!connect$board){
      actionButton("Serial_port_connect","Connect the board")
    }else{
      actionButton("Serial_port_disconnect","Disconnect the board")
    }
  })
  observeEvent(input$Serial_port_connect,{
    
    print("Connecting")
    main$connect_board(input$Serial_port) ## py
    # python.call("connect_board",input$Serial_port) ## py
    print("Connected")
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

  source("server_Method.R",local = T)  
  

  
  output$Log = renderDataTable({
    input$Log_refresh
    read.table("log/log.txt",header = T,sep = ";")
  })
  

  output$About_table_inventory = renderTable({
    read.csv("tables/inventory.csv",header=T,sep=";")
  })
  
  
})
