## server_TLC_MS for OC_manager
##
TLC_MS_x_width = 2000
TLC_MS_y_height = 1000
TLC_MS_x_bias = 4.5
TLC_MS_y_bias = 7

TLC_pins = c(laser=59,rheodyn=66,heading=64,rinsing=44) ## just reminder, not used in the code...

TLC_MS_before = 
  "G28 X0
G90
G1 F2000
G92 Y130 Z130
G1 Y0 Z0
G28 Y0 Z0"

TLC_MS_between = 
  "M42 P63 S255; close contact
G4 P200; wait security
M42 P63 S0; open contact
M42 P64 S255; head down
G4 P1000; waiting security
M42 P66 S255; activate rheodyn
G4 P2000; insert numeric elution time
M42 P66 S0; deactivate rheodyn
G4 P1000; waiting security
M42 P64 S0; head up
G4 P1000; waiting security
M42 P44 S255; purge start
G4 P1000; waiting security
M42 P44 S0; purge stop
G4 P2000; insert numeric rinsing time"


TLC_MS_after = 
  "M42 P59 S255
G4 P2000
M42 P59 S0
G4 P2000
G1 X100 Y130 Z130
M84"

TLC_MS_manual = reactiveValues(LED=F,head=F,elution=F)

output$TLC_MS_control_manual = renderUI({
  tagList(if(!TLC_MS_manual$LED){actionButton("TLC_MS_manual_LED_on","LED on")}else{actionButton("TLC_MS_manual_LED_off","LED off")},hr(),
          if(!TLC_MS_manual$head){actionButton("TLC_MS_manual_head_down","Head down")}else{actionButton("TLC_MS_manual_head_up","Head up")},hr(),
          if(!TLC_MS_manual$head){actionButton("TLC_MS_manual_rinsing","Purge head")},hr(),
          if(TLC_MS_manual$elution){actionButton("TLC_MS_manual_Valve_bypass","Valve bypass")}else{actionButton("TLC_MS_manual_Valve_elution","Valve elution")}
          )
  
})

output$TLC_MS_control_1 = renderUI({
  
  tabsetPanel(
    tabPanel("Input/output",
             sidebarLayout(
               sidebarPanel(width = 3,
                 fileInput("TLC_MS_fileInput",label = "picture(s) file(s)",multiple = T),
                 numericInput("TLC_MS_elution_time","Elution time in ms",20000),
                 numericInput("TLC_MS_rinsing_time","After rinsing time in ms",20000),
                 actionButton("TLC_MS_manual", "Manual control",icon = icon("edit")),
                 bsModal("TLC_MS_manualModal", "TLC_MS_manual", "TLC_MS_manual", size = "large",
                         uiOutput("TLC_MS_control_manual")
                 ),
                 textOutput("TLC_MS_batch_feedback"),
                 actionButton("TLC_MS_delete_last","Delete last"),
                 actionButton("TLC_MS_delete_all","Delete all"),
                 actionButton("TLC_MS_batch_action","Run batch"),
                 # actionButton("TLC_MS_batch_stop","Emergency stop"),
                 tableOutput("TLC_MS_table")
               ),
               mainPanel(width=9,
                         column(6,
                                plotOutput("TLC_MS_pict.1",dblclick="TLC_MS_dblclick.pict",brush = brushOpts(id = "TLC_MS_brush.pict",resetOnNew = TRUE),height = 300),
                                plotOutput("TLC_MS_pict.2",dblclick="TLC_MS_dblclick.pict",brush = brushOpts(id = "TLC_MS_brush.pict",resetOnNew = TRUE),height = 300),
                                plotOutput("TLC_MS_pict.3",dblclick="TLC_MS_dblclick.pict",brush = brushOpts(id = "TLC_MS_brush.pict",resetOnNew = TRUE),height = 300),
                                plotOutput("TLC_MS_pict.4",dblclick="TLC_MS_dblclick.pict",brush = brushOpts(id = "TLC_MS_brush.pict",resetOnNew = TRUE),height = 300)
                         ),
                         column(6,
                                plotOutput("TLC_MS_pict.1.zoom",click="TLC_MS_click.pict",height = 300),
                                plotOutput("TLC_MS_pict.2.zoom",click="TLC_MS_click.pict",height = 300),
                                plotOutput("TLC_MS_pict.3.zoom",click="TLC_MS_click.pict",height = 300),
                                plotOutput("TLC_MS_pict.4.zoom",click="TLC_MS_click.pict",height = 300)
                         )
                 
               )
             )
             ),
    tabPanel("Options",
             column(6,
                    textAreaInput("TLC_MS_batch_before","Before batch",value = TLC_MS_before,height = "200px"),
                    textAreaInput("TLC_MS_batch_between","Between head",value = TLC_MS_between,height = "200px"),
                    textAreaInput("TLC_MS_batch_after","After batch",value = TLC_MS_after,height = "200px")
                    ),
             column(6,
                    textInput("TLC_MS_color","Color on plots","red")#,
                    # numericInput("TLC_MS_x_bias","TLC_MS_x_bias",-5),
                    # numericInput("TLC_MS_y_bias","TLC_MS_y_bias",-5)
                    )
                    
         )
  )
})

observeEvent(input$TLC_MS_manual_LED_on,{
  validate(need(connect$login,"Please login"))
  gcode = c("M42 P59 S255")
  test_ink_file = paste0("gcode/","test_ink",".gcode")
  Log = test_ink_file
  fileConn<-file(test_ink_file)
  writeLines(gcode, fileConn)
  close(fileConn)
  # send the gcode
  main$send_gcode(test_ink_file)
  TLC_MS_manual$LED = T
})

observeEvent(input$TLC_MS_manual_LED_off,{
  validate(need(connect$login,"Please login"))
  gcode = c("M42 P59 S0")
  test_ink_file = paste0("gcode/","test_ink",".gcode")
  Log = test_ink_file
  fileConn<-file(test_ink_file)
  writeLines(gcode, fileConn)
  close(fileConn)
  # send the gcode
  main$send_gcode(test_ink_file)
  TLC_MS_manual$LED = F
})

observeEvent(input$TLC_MS_manual_head_down,{
  validate(need(connect$login,"Please login"))
  gcode = c("M42 P64 S255")
  test_ink_file = paste0("gcode/","test_ink",".gcode")
  Log = test_ink_file
  fileConn<-file(test_ink_file)
  writeLines(gcode, fileConn)
  close(fileConn)
  # send the gcode
  main$send_gcode(test_ink_file)
  TLC_MS_manual$head = T
})

observeEvent(input$TLC_MS_manual_head_up,{
  validate(need(connect$login,"Please login"))
  gcode = c("M42 P64 S0")
  test_ink_file = paste0("gcode/","test_ink",".gcode")
  Log = test_ink_file
  fileConn<-file(test_ink_file)
  writeLines(gcode, fileConn)
  close(fileConn)
  # send the gcode
  main$send_gcode(test_ink_file)
  TLC_MS_manual$head = F
})
observeEvent(input$TLC_MS_manual_Valve_bypass,{
  validate(need(connect$login,"Please login"))
  gcode = c("M42 P66 S0")
  test_ink_file = paste0("gcode/","test_ink",".gcode")
  Log = test_ink_file
  fileConn<-file(test_ink_file)
  writeLines(gcode, fileConn)
  close(fileConn)
  # send the gcode
  main$send_gcode(test_ink_file)
  TLC_MS_manual$elution = F
})

observeEvent(input$TLC_MS_manual_Valve_elution,{
  validate(need(connect$login,"Please login"))
  gcode = c("M42 P66 S255")
  test_ink_file = paste0("gcode/","test_ink",".gcode")
  Log = test_ink_file
  fileConn<-file(test_ink_file)
  writeLines(gcode, fileConn)
  close(fileConn)
  # send the gcode
  main$send_gcode(test_ink_file)
  TLC_MS_manual$elution = T
})

observeEvent(input$TLC_MS_manual_rinsing,{
  validate(need(!TLC_MS_manual$head,"Head down"),
           need(connect$login,"Please login"))
  gcode = c("M42 P44 S255","G4 P2000","M42 P44 S0")
  test_ink_file = paste0("gcode/","test_ink",".gcode")
  Log = test_ink_file
  fileConn<-file(test_ink_file)
  writeLines(gcode, fileConn)
  close(fileConn)
  # send the gcode
  main$send_gcode(test_ink_file)
})


TLC_MS_files <- reactive({
  validate(
    need(!is.null(input$TLC_MS_fileInput), "Please upload the pictures")#,
    # need(!grepl("csv",input$TLC_MS_fileInput$name),"No pictures for csv files")
  )
  if(grepl("csv",input$TLC_MS_fileInput$name)){
    data=list(array(1,dim=c(TLC_MS_y_height,TLC_MS_x_width,3)))
  }else{
    data=f.read.image(input$TLC_MS_fileInput$datapath, height = TLC_MS_y_height,ls.format = T)
  }
  
  data
})
observeEvent(input$TLC_MS_fileInput,{
  if(grepl("csv",input$TLC_MS_fileInput$name)){
    data = read.table(input$TLC_MS_fileInput$datapath,header=T,sep=",")
    TLC_MS_coord$x = data$x
    TLC_MS_coord$y = data$y
    # print("test")
  }
})
TLC_MS_files_name<- reactive({
  validate(
    need(!is.null(input$TLC_MS_fileInput), "Please upload the pictures")
  )
  input$TLC_MS_fileInput$name
})

TLC_MS_coord <- reactiveValues(x=NULL,y=NULL)
TLC_MS_zoom <- reactiveValues(x=c(0,TLC_MS_x_width),y=c(0,TLC_MS_y_height))


## click on band one after another: G90 and G1
observeEvent(input$TLC_MS_click.pict,{
  x = round(input$TLC_MS_click.pict$x,1)/10
  y = round(input$TLC_MS_click.pict$y,1)/10
  TLC_MS_coord$x <- c(TLC_MS_coord$x,x)
  TLC_MS_coord$y <- c(TLC_MS_coord$y,y)
})

observeEvent(input$TLC_MS_dblclick.pict,{
  brush <- input$TLC_MS_brush.pict
  if (!is.null(brush)) {
    TLC_MS_zoom$x <- c(brush$xmin, brush$xmax)
    TLC_MS_zoom$y <- c(brush$ymin, brush$ymax)
  } else {
    TLC_MS_zoom$x <- c(0,TLC_MS_x_width)
    TLC_MS_zoom$y <- c(0,TLC_MS_y_height)
  }
})

observeEvent(input$TLC_MS_delete_last,{
  if(length(TLC_MS_coord$x) == 1){
    TLC_MS_coord$x = NULL
    TLC_MS_coord$y = NULL
  }
  if(length(TLC_MS_coord$x) > 1){
    TLC_MS_coord$x = TLC_MS_coord$x[1:(length(TLC_MS_coord$x)-1)]
    TLC_MS_coord$y = TLC_MS_coord$y[1:(length(TLC_MS_coord$y)-1)]
  }
})

observeEvent(input$TLC_MS_delete_all,{
  TLC_MS_coord$x = NULL
  TLC_MS_coord$y = NULL
})


output$TLC_MS_pict.1 <- renderPlot({
  par(mar=c(0,0,3,0))
  raster(TLC_MS_files()[[1]],main=TLC_MS_files_name()[1],xlim=c(0,TLC_MS_x_width),ylim=c(0,TLC_MS_y_height))
})
output$TLC_MS_pict.1.zoom <- renderPlot({
  par(mar=c(0,0,3,0))
  raster(TLC_MS_files()[[1]],main=TLC_MS_files_name()[1],xlim=TLC_MS_zoom$x,ylim=TLC_MS_zoom$y)
  if(!is.null(TLC_MS_coord$x)){
    text(x=TLC_MS_coord$x*10,y=TLC_MS_coord$y*10-10,label=seq(length(TLC_MS_coord$x)),col=input$TLC_MS_color,pos = 3,cex=0.5)
    symbols(x=TLC_MS_coord$x*10,y=TLC_MS_coord$y*10,fg=input$TLC_MS_color,inches = F,add = T,rectangles = cbind(rep(4*10,length(TLC_MS_coord$x)),rep(2*10,length(TLC_MS_coord$x))))
  }
})
output$TLC_MS_pict.2 <- renderPlot({
  validate(
    need(length(TLC_MS_files()) > 1, "Not enough pictures")
  )
  par(mar=c(0,0,3,0))
  raster(TLC_MS_files()[[2]],main=TLC_MS_files_name()[2],xlim=c(0,TLC_MS_x_width),ylim=c(0,TLC_MS_y_height))
})
output$TLC_MS_pict.2.zoom <- renderPlot({
  validate(
    need(length(TLC_MS_files()) > 1, "Not enough pictures")
  )
  par(mar=c(0,0,3,0))
  raster(TLC_MS_files()[[2]],main=TLC_MS_files_name()[2],xlim=TLC_MS_zoom$x,ylim=TLC_MS_zoom$y)
  if(!is.null(TLC_MS_coord$x)){
    text(x=TLC_MS_coord$x*10,y=TLC_MS_coord$y*10,label=seq(length(TLC_MS_coord$x)),col=input$TLC_MS_color,pos = 3)
    symbols(x=TLC_MS_coord$x*10,y=TLC_MS_coord$y*10,fg=input$TLC_MS_color,inches = F,add = T,rectangles = cbind(rep(input$TLC_MS_head_width*10,length(TLC_MS_coord$x)),rep(input$TLC_MS_head_height*10,length(TLC_MS_coord$x))))
  }
})
output$TLC_MS_pict.3 <- renderPlot({
  validate(
    need(length(TLC_MS_files()) > 2, "Not enough pictures")
  )
  par(mar=c(0,0,3,0))
  raster(TLC_MS_files()[[3]],main=TLC_MS_files_name()[3],xlim=c(0,TLC_MS_x_width),ylim=c(0,TLC_MS_y_height))
})
output$TLC_MS_pict.3.zoom <- renderPlot({
  validate(
    need(length(TLC_MS_files()) > 2, "Not enough pictures")
  )
  par(mar=c(0,0,3,0))
  raster(TLC_MS_files()[[3]],main=TLC_MS_files_name()[3],xlim=TLC_MS_zoom$x,ylim=TLC_MS_zoom$y)
  if(!is.null(TLC_MS_coord$x)){
    text(x=TLC_MS_coord$x*10,y=TLC_MS_coord$y*10,label=seq(length(TLC_MS_coord$x)),col=input$TLC_MS_color,pos = 3)
    symbols(x=TLC_MS_coord$x*10,y=TLC_MS_coord$y*10,fg=input$TLC_MS_color,inches = F,add = T,rectangles = cbind(rep(input$TLC_MS_head_width*10,length(TLC_MS_coord$x)),rep(input$TLC_MS_head_height*10,length(TLC_MS_coord$x))))
  }
})
output$TLC_MS_pict.4 <- renderPlot({
  validate(
    need(length(TLC_MS_files()) > 3, "Not enough pictures")
  )
  par(mar=c(0,0,3,0))
  raster(TLC_MS_files()[[4]],main=TLC_MS_files_name()[4],xlim=c(0,TLC_MS_x_width),ylim=c(0,TLC_MS_y_height))
})
output$TLC_MS_pict.4.zoom <- renderPlot({
  validate(
    need(length(TLC_MS_files()) > 3, "Not enough pictures")
  )
  par(mar=c(0,0,3,0))
  raster(TLC_MS_files()[[4]],main=TLC_MS_files_name()[4],xlim=TLC_MS_zoom$x,ylim=TLC_MS_zoom$y)
  if(!is.null(TLC_MS_coord$x)){
    text(x=TLC_MS_coord$x*10,y=TLC_MS_coord$y*10,label=seq(length(TLC_MS_coord$x)),col=input$TLC_MS_color,pos = 3)
    symbols(x=TLC_MS_coord$x*10,y=TLC_MS_coord$y*10,fg=input$TLC_MS_color,inches = F,add = T,rectangles = cbind(rep(input$TLC_MS_head_width*10,length(TLC_MS_coord$x)),rep(input$TLC_MS_head_height*10,length(TLC_MS_coord$x))))
  }
})

TLC_MS_table.dim <- reactive({
  validate(
    need(length(TLC_MS_coord$x) >= 1, "Not enough extraction selected")
  )
  data <- data.frame(pictX = TLC_MS_coord$x, pictY = TLC_MS_coord$y)
  data$extraction = seq(nrow(data))
  data$x_mm = data$pictX# * x_resolution
  data$y_mm = data$pictY# * y_resolution
  # data$reverse_y = 100 - data$y
  # data$Rt = rep(" ",nrow(data))
  # data$mz_pos = rep(" ",nrow(data))
  # data$mz_neg = rep(" ",nrow(data))
  # data$remark = rep(" ",nrow(data))
  data[,3:ncol(data)]
})

output$TLC_MS_table <- renderTable({
  TLC_MS_table.dim()
})

TLC_MS_feedback = reactiveValues(text="no feedback yet")
output$TLC_MS_batch_feedback = renderText({
  TLC_MS_feedback$text
})
observeEvent(input$TLC_MS_cmd_button,{
  test_ink_file = "gcode/test_ink_cmd.gcode"
  Log = test_ink_file
  fileConn<-file(test_ink_file)
  writeLines(input$TLC_MS_cmd, fileConn)
  close(fileConn)  # send the gcode
  main$send_gcode(test_ink_file)
})

TLC_MS_gcode = reactive({
  gcode = c()
  ## before
  for(i in unlist(strsplit(input$TLC_MS_batch_before,split = "\n"))){
    gcode = c(gcode,i)
  }
  ## head loop
  for(i in seq(length(TLC_MS_coord$x))){
    ## moving to position
    gcode = c(gcode,paste0("G1 Z",TLC_MS_coord$y[i]+TLC_MS_y_bias," Y",TLC_MS_coord$y[i]+TLC_MS_y_bias))
    gcode = c(gcode,paste0("G1 X",TLC_MS_coord$x[i]+TLC_MS_x_bias))
    gcode = c(gcode,"M400")
    gcode = c(gcode,"G4 P1000")
    ## between
    for(j in unlist(strsplit(input$TLC_MS_batch_between,split = "\n"))){
      if(j == "G4 P2000; insert numeric elution time"){
        j = paste0("G4 P",input$TLC_MS_elution_time,"; insert numeric elution time")
      }
      if(j == "G4 P2000; insert numeric rinsing time"){
        j = paste0("G4 P",input$TLC_MS_rinsing_time,"; insert numeric rinsing time")
      }
      gcode = c(gcode,j)
    }
  }
  ## after
  for(i in unlist(strsplit(input$TLC_MS_batch_after,split = "\n"))){
    gcode = c(gcode,i)
  }
  gcode
})

observeEvent(input$TLC_MS_batch_action,{
    # create the gcode
    Method_file = paste0("gcode/","Method",".gcode")
    Log = Method_file
    fileConn<-file(Method_file)
    writeLines(TLC_MS_gcode(), fileConn)
    close(fileConn)
    # put it in the log
    write(paste0(format(Sys.time(),"%Y%m%d_%H:%M:%S"),";","TLC_MS",";",Log,";",Log,";",connect$Visa,";",input$Plate),file="log/log.txt",append = T)
    # send the gcode
    # if(!is.null(rv$id$pid)) return()
    # if(input$Serial_windows){
      main$send_gcode(Method_file)
    # }else{
    #   rv$id <- mcparallel({ main$send_gcode(Method_file)}) #python.call("test_stop")
    # }
    
    TLC_MS_feedback$text = "batch finished"
  
})
observeEvent(input$TLC_MS_batch_stop,{
  # validate(need(!input$Serial_windows,"not on windows"))
  # if(!is.null(rv$id$pid)){
  #   tools::pskill(rv$id$pid)
  #   TLC_MS_feedback$text = "batch killed"
  #   rv$id <- list()
  # }
  main$cancel(Method_file)
})
