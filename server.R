
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(rPython)
library(DLC)

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
  python.load("setup.py")
  session$onSessionEnded(function() {
    # if(connect$board){
      python.call("close_connections")
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
        python.call("close_connections")
        # put it in the log
        write(paste0(format(Sys.time(),"%Y%m%d_%H:%M:%S"),";","Connection;",NA,";","Board disconnection",";",connect$Visa,";",input$Plate),file="log/log.txt",append = T)
        connect$board = F
      }
    }
  })
  
  output$Serial_port = renderUI({
    input$Serial_port_refresh
    if(input$Serial_windows){
      selectizeInput("Serial_port","select Serial port",choices = c("COM3","COM4"))
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
    python.call("connect_board",input$Serial_port)
    # put it in the log
    write(paste0(format(Sys.time(),"%Y%m%d_%H:%M:%S"),";","Connection;",NA,";","Board connection",";",connect$Visa,";",input$Plate),file="log/log.txt",append = T)
    connect$board = T
  })
  observeEvent(input$Serial_port_disconnect,{
    python.call("close_connections")
    # put it in the log
    write(paste0(format(Sys.time(),"%Y%m%d_%H:%M:%S"),";","Connection;",NA,";","Board disconnection",";",connect$Visa,";",input$Plate),file="log/log.txt",append = T)
    connect$board = F
  })
  observeEvent(input$Serial_port_disconnect_bis,{
    python.call("close_connections")
    connect$board = F
  })
  
  TempInvalidate <- reactiveTimer(2000)
  output$LP_control_1 = renderUI({
    validate(
      need(connect$board,"Please connect the board")
    )
    TempInvalidate()
    full = python.call("get_temp")
    # full = gsub(pattern = "ok T:0.0 /0.0 B:",x = full,replacement = "Bed temp: ")
    # full = gsub(pattern = "@:0 B@:0",x = full,replacement = "°C")
    tagList(
      h6(full)
    )
  })
  output$LP_control_2 = renderUI({
    validate(
      need(connect$board,"Please connect the board")
    )
    tagList(
      textInput("LP_file_name","file name",paste0(input$LP_first_appli,"_",input$LP_Y_length,"_",input$LP_gap,"_",
                                                  input$LP_nbr_track,"_",input$LP_microL_per_dm,"_",
                                                  input$LP_Z_offset,"_",input$LP_speed)),
      
      actionButton("LP_action","Launch Gcode"),
      uiOutput("LP_infoGcode")
    )
  })
  output$LP_control_3 = renderUI({
    validate(
      need(connect$board,"Please connect the board")
    )
    tagList(
      numericInput("temperature","temp °C",105),
      actionButton("set_temp","Set"),
      actionButton("LP_E1",label = "Extrude 1 mm"),
      actionButton("LP_E5",label = "Extrude 5 mm")
    )
  })
  observeEvent(input$set_temp,{
    python.call("set_temp",input$temperature)
  })
  observeEvent(input$LP_action,{
    # create the gcode
    LP_file = paste0("gcode/",format(Sys.time(),"%Y%m%d_%H:%M:%S"),input$LP_file_name,".gcode")
    Log = LP_file
    fileConn<-file(LP_file)
    writeLines(LP_gcode(), fileConn)
    close(fileConn)
    # put it in the log
    write(paste0(format(Sys.time(),"%Y%m%d_%H:%M:%S"),";","layer_printing;",LP_file,";",Log,";",connect$Visa,";",input$Plate),file="log/log.txt",append = T)
    # send the gcode
    python.call("send_gcode",LP_file)
  })
  observeEvent(input$LP_E1,{
    truc = c("G21 ; set units to millimeters",
             "G90 ; use absolute coordinates",
             "M82 ; use absolute distances for extrusion",
             "G92 E0",
             "G1 F3600 ; set speed in mm per min for the movement",
             "G1 E1")
    # create the gcode
    LP_test = "gcode/LP_cmd.gcode"
    Log = LP_test
    fileConn<-file(LP_test)
    writeLines(truc, fileConn)
    close(fileConn)  # send the gcode
    python.call("send_gcode",LP_test)
  })
  observeEvent(input$LP_E5,{
    truc = c("G21 ; set units to millimeters",
             "G90 ; use absolute coordinates",
             "M82 ; use absolute distances for extrusion",
             "G92 E0",
             "G1 F3600 ; set speed in mm per min for the movement",
             "G1 E5")
    # create the gcode
    LP_test = "gcode/LP_cmd.gcode"
    Log = LP_test
    fileConn<-file(LP_test)
    writeLines(truc, fileConn)
    close(fileConn)  # send the gcode
    python.call("send_gcode",LP_test)
  })
  LP_applications <- reactive({
    track_gap = input$LP_gap - (input$LP_nbr_path-1)*input$LP_gap_path
    if(input$LP_nbr_path != 1  && input$LP_nbr_track != 1){
      validate(need(track_gap > input$LP_gap_path,"the track gap in <= to the path gap"))
    }
    validate(need(input$LP_Y_length<=100,"Y_length > 100"))
    Y_small = input$LP_bottom_dist
    Y_big = input$LP_bottom_dist + input$LP_Y_length
    X_gap = c()
    for(i in seq(input$LP_nbr_track)){
      X_gap = c(X_gap,rep(input$LP_gap_path,input$LP_nbr_path-1))
      X_gap = c(X_gap,track_gap)
    }
    mat  =rbind(c(NA,NA,input$LP_first_appli - (input$LP_nbr_path-1)/2*input$LP_gap_path,Y_small,0))
    for(i in seq(length(X_gap))){
      vec = c(mat[nrow(mat),3],mat[nrow(mat),4],mat[nrow(mat),3],0,0) 
      if(mat[nrow(mat),4] == Y_small){vec[4] = Y_big}else{vec[4] = Y_small}
      vec[5] = mat[nrow(mat),5] + abs(vec[2] - vec[4]) /100 * input$LP_microL_per_dm / 1000 * input$LP_syringe_ratio
      # print(vec)
      mat  =rbind(mat,vec)
      if(i != length(X_gap)){
        vec = c(vec[3],vec[4],vec[3]+X_gap[i],vec[4],vec[5])
        vec[5] = vec[5] + abs(vec[1] - vec[3]) /100 * input$LP_microL_per_dm / 1000 * input$LP_syringe_ratio
        # print(vec)
        mat  =rbind(mat,vec)
      }
    }
    mat[,5] = round(mat[,5],5)
    mat
  })
  output$LP_infoGcode = renderUI({
    tagList(
      h6(paste0("Track are ",(input$LP_nbr_path-1)*input$LP_gap_path," mm large (without counting the outside)")),
      h6(paste0("Track are ",(input$LP_nbr_path)*input$LP_gap_path," mm large (counting the outside)")),
      h6(paste0("Surface is ",(input$LP_nbr_path)*input$LP_gap_path*input$LP_nbr_track*input$LP_Y_length," mm2 large (counting the outside), 1 dm2 = 10000 mm2")),
      h6(paste0((LP_applications()[nrow(LP_applications()),5] / input$LP_syringe_ratio)," mL use in this print"))#,
      #verbatimTextOutput("LP_memory")
    )
    
  })
  output$LP_memory = renderPrint({
    truc = system("df -h",intern = T)
    truc
  })
  output$LP_plot <- renderPlot({
    plot(x=0,y=0,type="n",xlim=c(0,200),ylim=c(0,100),xlab="X",ylab="Y",sub = "note that the plate is reversed on the printer")
    segments(x0=LP_applications()[,1],x1 = LP_applications()[,3],y0 = LP_applications()[,2],y1 = LP_applications()[,4])
  })
  LP_gcode <- reactive({
    vec = c(
      #paste0("; Produce with OC_manager, ",date()),
      "G28 ; home all axis, will have a problem with the Z",
      "G29 ; perform bed levelling",
      "G21 ; set units to millimeters",
      "G90 ; use absolute coordinates",
      "M82 ; use absolute distances for extrusion",
      "G92 E0")
    if(input$LP_temp != 0){vec = c(vec,paste0("M190 S",input$LP_temp," ; set temperature"))}
    vec = c(vec,
            paste0("G1 F",60*input$LP_speed," ; set speed in mm per min for the movement"),
            paste0("G1 Z",input$LP_Z_offset," ; go in Z offset position"),
            paste0("G1 X",LP_applications()[1,3]," Y",LP_applications()[1,4]," ; go in first position")
    )
    for(i in 2:nrow(LP_applications())){
      vec <- c(vec,paste0("G1 X",LP_applications()[i,3]," Y",LP_applications()[i,4]," E",LP_applications()[i,5]))
    }
    vec2 = c("G92 E0",
             "G1 Z5; move Z 5 mm upper",
             paste0("G1 E-",LP_applications()[nrow(LP_applications()),5]+10,"; move the piston pusher up"),
             "M84     ; disable motors")
    c(vec,vec2)
  })
  output$LP_gcode <- renderDataTable({
    data.frame(gcode = LP_gcode())
  },options = list(pageLength = 10))
  
  source("server_SA.R",local = T)
  
  source("server_Dev.R",local = T)
  
  source("server_Deriv.R",local = T)

  source("server_Method.R",local = T)  
  

  
  output$Log = renderDataTable({
    input$Log_refresh
    read.table("log/log.txt",header = T,sep = ";")
  })
  
  ## old Visu part
  # Visu_pict = reactiveValues(data=NULL)
  # observeEvent(input$Visu_action,{
  #   # create the gcode
  #   Visu_file = paste0("pictures/",format(Sys.time(),"%Y%m%d_%H:%M:%S"),".jpg")
  #   Visu_file = gsub(" ","_",Visu_file)
  #   
  #   # command = paste("raspistill","-w",input$Visu_width,"-h",input$Visu_height,"-n","-o",Visu_file,"--shutter",input$Visu_shutter,
  #   #                 "--timeout",input$Visu_timeout,"--sharpness",input$Visu_sharpness,"--contrast",input$Visu_contrast,
  #   #                 "--brightness",input$Visu_brightness,"--saturation",input$Visu_saturation,"--ISO",input$Visu_ISO,
  #   #                 "--exposure",input$Visu_exposure,"--awb",input$Visu_AWB,sep=" ")
  #   command = paste("raspistill","-o",Visu_file,"-ss",input$Visu_shutter*1000,"-ISO",input$Visu_ISO)
  #   
  #   Log = command
  #   # put it in the log
  #   write(paste0(format(Sys.time(),"%Y%m%d_%H:%M:%S"),";","Visualisation;",Visu_file,";",Log,";",connect$Visa,";",input$Plate),file="log/log.txt",append = T)
  #   # send the gcode
  #   # python.call("Visu_take",Visu_file)
  #   
  #   print(command)
  #   system(command)
  #   Visu_pict$data = f.read.image(Visu_file)
  # })
  # output$Visu_explore_select = renderUI({
  #   data = Visu_pict$data # just for reactivity
  #   selectizeInput("Visu_explore_select","Select the picture to show",choices = dir("pictures",full.names = T),selected=NULL)
  # })
  # # output$Visu_plot = renderPlot({
  # #   validate(need(!is.null(Visu_pict$data),"Take a picture."))
  # #   par(mar=rep(0,4),xaxs="i",yaxs="i")
  # #   DLC::raster(Visu_pict$data,height=1000)
  # # })
  # output$Visu_plot = renderImage({
  #   validate(need(!is.null(Visu_pict$data),"Take a picture."))
  #   par(mar=rep(0,4),xaxs="i",yaxs="i")
  #   DLC::raster(Visu_pict$data,height=1000)
  # })
  # # output$Visu_explore_plot = renderPlot({
  # #   validate(need(!is.null(input$Visu_explore_select),"Select a picture."))
  # #   data = f.read.image(input$Visu_explore_select)
  # #   par(mar=rep(0,4),xaxs="i",yaxs="i")
  # #   DLC::raster(data,height=1000)
  # # })
  # output$Visu_explore_plot <- renderImage({
  #   validate(need(!is.null(input$Visu_explore_select),"Select a picture."))
  #   # When input$n is 1, filename is ./images/image1.jpeg
  #   # filename <- normalizePath(file.path('./images',
  #   #                                     paste('image', input$n, '.jpeg', sep='')))
  #   
  #   # Return a list containing the filename
  #   list(src = input$Visu_explore_select,
  #        width = 500,
  #        height = 500)
  # }, deleteFile = FALSE)
  # output$Visu_explore_plot_bis = renderUI({
  #   HTML(paste0(" <img src='/home/pi/OC_manager/",input$Visu_explore_select,"'> "))
  # })
  
  output$About_table_inventory = renderTable({
    read.csv("tables/inventory.csv",header=T,sep=";")
  })
  
  
})
