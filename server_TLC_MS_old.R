## server_TLC_MS for OC_manager
##
TLC_MS_x_width = 2000
TLC_MS_y_height = 1000

TLC_pins = c(laser=59,rheodyn=66,stamping=64,cleaning=44)

truc = "
# before
G28 Y0; bypass
G4 P1000
G28 X0;purge
G4 P1000
G1 X10;X middle
G4 P1000


## between
G1 X20; stamp
G4 P1000
G1 Y20; elute
G4 P2000; insert numeric stamp time
G1 Y0; bypass
G4 P1000
G1 X10;X middle
G4 P1000
G1 X0; purge
G4 P1000
G1 X10;X middle
G4 P1000

## after
G1 E100
G1 Z90
M84;disable motor
"

TLC_MS_before = paste(
  "G28 Y0; bypass",
  "G4 P1000",
  "G28 X0;purge",
  "G4 P1000",
  "G1 X10;X middle",
  "G4 P1000",sep = "\n")

TLC_MS_between = paste(
  "G1 X20; stamp",
  "G4 P1000",
  "G1 Y20; elute",
  "G4 P2000; insert numeric stamp time",
  "G1 Y0; bypass",
  "G4 P1000",
  "G1 X10;X middle",
  "G4 P1000",
  "G1 X0; purge",
  "G4 P1000",
  "G1 X10;X middle",
  "G4 P1000",sep = "\n")

TLC_MS_after = paste(
  "G1 E100",
  "G1 Z90",
  "M84",sep = "\n")

output$TLC_MS_control_1 = renderUI({
  
  tabsetPanel(
    tabPanel("Input/output",
             sidebarLayout(
               sidebarPanel(width = 2,
                 fileInput("TLC_MS_files",label = "picture(s) file(s)",multiple = T),
                 numericInput("TLC_MS_cropping","cropping (mm)",value=NULL),
                 numericInput("TLC_MS_stamp_width","stamp width (mm)",value=4),
                 numericInput("TLC_MS_stamp_height","stamp height (mm)",value=2),
                 checkboxInput("TLC_MS_batch_mode","Use in batch mode",TRUE),
                 textInput("TLC_MS_cmd","test_ink_cmd","M400"),
                 actionButton("TLC_MS_cmd_button","test_ink_cmd_button"),
                 actionButton("TLC_MS_laser","Turn on laser")
               ),
               mainPanel(width=10,
                 plotOutput("TLC_MS_pict.calib",dblclick="TLC_MS_dblclick.pict.1",brush = brushOpts(id = "TLC_MS_brush.pict.1",resetOnNew = TRUE)),
                 plotOutput("TLC_MS_pict.calib.zoom",click="TLC_MS_click.pict.calib"),
                 column(6,
                        plotOutput("TLC_MS_pict.cartesian",click="TLC_MS_click.pict.cartesian")
                 ),
                 column(6,
                        p("It is necessary to calibrate the apparatus before use, to do so, mark a zone on the plate and select it on the picture bellow,
                                          then use the next plot to move to the position and validate the system with the button"), ## review this instruction
                        uiOutput("TLC_MS_calib_pict"),
                        actionButton("TLC_MS_validateSystem",icon = icon("check"),label = "Validate System"),
                        actionButton("TLC_MS_G92ichh",icon = icon("check"),label = "TLC_MS_G92ichh")#TLC_MS_G92ichh
                 )
                 
               )
             )),
    tabPanel("Chromatograms",
             column(6,
                    plotOutput("TLC_MS_pict.1",dblclick="TLC_MS_dblclick.pict.1",brush = brushOpts(id = "TLC_MS_brush.pict.1",resetOnNew = TRUE),height = 300),
                    plotOutput("TLC_MS_pict.2",dblclick="TLC_MS_dblclick.pict.2",brush = brushOpts(id = "TLC_MS_brush.pict.2",resetOnNew = TRUE),height = 300),
                    plotOutput("TLC_MS_pict.3",dblclick="TLC_MS_dblclick.pict.3",brush = brushOpts(id = "TLC_MS_brush.pict.3",resetOnNew = TRUE),height = 300),
                    plotOutput("TLC_MS_pict.4",dblclick="TLC_MS_dblclick.pict.4",brush = brushOpts(id = "TLC_MS_brush.pict.4",resetOnNew = TRUE),height = 300)
             ),
             column(6,
                    plotOutput("TLC_MS_pict.1.zoom",click="TLC_MS_click.pict.1",height = 300),
                    plotOutput("TLC_MS_pict.2.zoom",click="TLC_MS_click.pict.2",height = 300),
                    plotOutput("TLC_MS_pict.3.zoom",click="TLC_MS_click.pict.3",height = 300),
                    plotOutput("TLC_MS_pict.4.zoom",click="TLC_MS_click.pict.4",height = 300)
             )
    ),
    tabPanel("Table",
             tableOutput("TLC_MS_table"),
             actionButton("TLC_MS_delete_last","delete last"),
             actionButton("TLC_MS_delete_all","delete all")
    ),
    tabPanel("Batch mode",
             column(4,
                    textAreaInput("TLC_MS_batch_before","Before batch",value = TLC_MS_before,height = "200px"),
                    textAreaInput("TLC_MS_batch_between","Between stamp",value = TLC_MS_between,height = "200px"),
                    textAreaInput("TLC_MS_batch_after","After batch",value = TLC_MS_after,height = "200px")
                    ),
             column(4,
                    tableOutput("TLC_MS_batch_table")
                    ),
             column(4,
                    actionButton("TLC_MS_batch_action","Run batch"),
                    actionButton("TLC_MS_batch_action_init","Run batch init"),
                    numericInput("TLC_MS_stamp_time","stamp time in ms (not yet)",3000),
                    textOutput("TLC_MS_batch_feedback")
                    )
         )
  )
})

TLC_MS_files <- reactive({
  validate(
    need(!is.null(input$TLC_MS_files), "Please upload the pictures")
  )
  validate(need(!is.null(input$TLC_MS_cropping),"Please input the cropping"))
  validate(need(input$TLC_MS_cropping == 0,"Please input a cropping of zero to assure correct alignment"))
  data=f.read.image(input$TLC_MS_files$datapath, height = TLC_MS_y_height,ls.format = T)
  data
})
TLC_MS_files_name<- reactive({
  validate(
    need(!is.null(input$TLC_MS_files), "Please upload the pictures")
  )
  input$TLC_MS_files$name
})
output$TLC_MS_calib_pict <- renderUI({
  selectizeInput("TLC_MS_calib_pict","select calibration picture (typically under white light)",choices = TLC_MS_files_name(),selected=TLC_MS_files_name()[1])
})

TLC_MS_coord <- reactiveValues(x=NULL,y=NULL)
TLC_MS_Validate_coord <- reactiveValues(x=NULL,y=NULL)
TLC_MS_zoom <- reactiveValues(x=c(0,TLC_MS_x_width),y=c(0,TLC_MS_y_height))
## Click on the plot to set the calibration coordinate, G92
observeEvent(input$TLC_MS_click.pict.calib,{
  TLC_MS_Validate_coord$x <- round(input$TLC_MS_click.pict.calib$x,1)/10
  TLC_MS_Validate_coord$y <- round(input$TLC_MS_click.pict.calib$y,1)/10
  main$send_cmd(paste0("G92 E",100," Z",50))
})
observeEvent(input$TLC_MS_G92ichh,{
  main$send_cmd(paste0("G92 E",100," Z",50))
})
## Click on the cartesian plot to move the head to , G91 and G1
observeEvent(input$TLC_MS_click.pict.cartesian,{
  x = round(input$TLC_MS_click.pict.cartesian$x)
  y = round(input$TLC_MS_click.pict.cartesian$y)
  if(y == 0){
    y = 0
  }else if(y > 0){
    y = - 10^(y-2)
  }else{
    y = 10^(abs(y)-2)
  }
  if(x == 0){
    x = 0
  }else if(x > 0){
    x = 10^(x-2)
  }else{
    x = - 10^(abs(x)-2)
  }
  main$send_cmd(paste0("G91"))# ; use relative positioning for the XYZ axes
  main$send_cmd(paste0("G1 Z",y," F200"))
  main$send_cmd(paste0("G1 E",x," F2000"))
})
## Validate system, G92
observeEvent(input$TLC_MS_validateSystem,{
  main$send_cmd(paste0("G92 E",TLC_MS_Validate_coord$x," Z",TLC_MS_Validate_coord$y))
})
## click on band one after another: G90 and G1
observeEvent(input$TLC_MS_click.pict.1,{
  x = round(input$TLC_MS_click.pict.1$x,1)/10
  y = round(input$TLC_MS_click.pict.1$y,1)/10
  if(!input$TLC_MS_batch_mode){
    main$send_cmd("G90")# ; use absolute positioning for the XYZ axes
    main$send_cmd(paste0("G1 Z",y," F200"))
    main$send_cmd(paste0("G1 E",x," F2000"))
  }
  TLC_MS_coord$x <- c(TLC_MS_coord$x,x)
  TLC_MS_coord$y <- c(TLC_MS_coord$y,y)
})
observeEvent(input$TLC_MS_click.pict.2,{
  x = round(input$TLC_MS_click.pict.2$x,1)/10
  y = round(input$TLC_MS_click.pict.2$y,1)/10
  if(!input$TLC_MS_batch_mode){
    main$send_cmd("G90")# ; use absolute positioning for the XYZ axes
    main$send_cmd(paste0("G1 Z",y," F200"))
    main$send_cmd(paste0("G1 E",x," F2000"))
  }
  TLC_MS_coord$x <- c(TLC_MS_coord$x,x)
  TLC_MS_coord$y <- c(TLC_MS_coord$y,y)
})
observeEvent(input$TLC_MS_click.pict.3,{
  x = round(input$TLC_MS_click.pict.3$x,1)/10
  y = round(input$TLC_MS_click.pict.3$y,1)/10
  if(!input$TLC_MS_batch_mode){
    main$send_cmd("G90")# ; use absolute positioning for the XYZ axes
    main$send_cmd(paste0("G1 Z",y," F200"))
    main$send_cmd(paste0("G1 E",x," F2000"))
  }
  TLC_MS_coord$x <- c(TLC_MS_coord$x,x)
  TLC_MS_coord$y <- c(TLC_MS_coord$y,y)
})
observeEvent(input$TLC_MS_click.pict.4,{
  x = round(input$TLC_MS_click.pict.4$x,1)/10
  y = round(input$TLC_MS_click.pict.4$y,1)/10
  if(!input$TLC_MS_batch_mode){
    main$send_cmd("G90")# ; use absolute positioning for the XYZ axes
    main$send_cmd(paste0("G1 Z",y," F200"))
    main$send_cmd(paste0("G1 E",x," F2000"))
  }
  TLC_MS_coord$x <- c(TLC_MS_coord$x,x)
  TLC_MS_coord$y <- c(TLC_MS_coord$y,y)
})

observeEvent(input$TLC_MS_dblclick.pict.1,{
  brush <- input$TLC_MS_brush.pict.1
  if (!is.null(brush)) {
    TLC_MS_zoom$x <- c(brush$xmin, brush$xmax)
    TLC_MS_zoom$y <- c(brush$ymin, brush$ymax)
  } else {
    TLC_MS_zoom$x <- c(0,TLC_MS_x_width)
    TLC_MS_zoom$y <- c(0,TLC_MS_y_height)
  }
})
observeEvent(input$TLC_MS_dblclick.pict.2,{
  brush <- input$TLC_MS_brush.pict.2
  if (!is.null(brush)) {
    TLC_MS_zoom$x <- c(brush$xmin, brush$xmax)
    TLC_MS_zoom$y <- c(brush$ymin, brush$ymax)
  } else {
    TLC_MS_zoom$x <- c(0,TLC_MS_x_width)
    TLC_MS_zoom$y <- c(0,TLC_MS_y_height)
  }
})
observeEvent(input$TLC_MS_dblclick.pict.3,{
  brush <- input$TLC_MS_brush.pict.3
  if (!is.null(brush)) {
    TLC_MS_zoom$x <- c(brush$xmin, brush$xmax)
    TLC_MS_zoom$y <- c(brush$ymin, brush$ymax)
  } else {
    TLC_MS_zoom$x <- c(0,TLC_MS_x_width)
    TLC_MS_zoom$y <- c(0,TLC_MS_y_height)
  }
})
observeEvent(input$TLC_MS_dblclick.pict.4,{
  brush <- input$TLC_MS_brush.pict.4
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

output$TLC_MS_pict.cartesian <- renderPlot({
  plot(c(-5,5),c(-5,5),type="n",
       xlab="X (mm)",ylab="Y (mm)",xaxt="n",yaxt="n",
       main=paste0("target X: ",TLC_MS_Validate_coord$x," - target Y: ",TLC_MS_Validate_coord$y,"\n in motor step"))
  text(y=c(-4,-3,-2,-1,1,2,3,4),x=rep(0,8),label=c("-100","-10","-1","-0.1","+0.1","+1","+10","+100"))
  text(x=c(-4,-3,-2,-1,1,2,3,4),y=rep(0,8),label=c("-100","-10","-1","-0.1","+0.1","+1","+10","+100"))
  symbols(y=c(-4,-3,-2,-1,1,2,3,4),x=rep(0,8),inches = F,add = T,rectangles = cbind(rep(0.8,8),rep(0.8,8)),lwd=2)
  symbols(x=c(-4,-3,-2,-1,1,2,3,4),y=rep(0,8),inches = F,add = T,rectangles = cbind(rep(0.8,8),rep(0.8,8)),lwd=2)
})



output$TLC_MS_pict.calib <- renderPlot({
  par(mar=c(0,0,3,0))
  truc = which(TLC_MS_files_name() == input$TLC_MS_calib_pict)
  raster(TLC_MS_files()[[truc]],main=paste0("Zoom (",TLC_MS_files_name()[which(TLC_MS_files_name() == input$TLC_MS_calib_pict)],")"),xlim=c(0,TLC_MS_x_width),ylim=c(0,TLC_MS_y_height))
  # if(!is.null(TLC_MS_Validate_coord$x)){
  #   text(x=TLC_MS_Validate_coord$x*10,y=TLC_MS_Validate_coord$y*10,label="X",col="red")
  #   symbols(x=TLC_MS_Validate_coord$x*10,y=TLC_MS_Validate_coord$y*10,fg="red",inches = F,add = T,rectangles = cbind(input$TLC_MS_stamp_width*10,input$TLC_MS_stamp_height*10))
  # }
})
output$TLC_MS_pict.calib.zoom <- renderPlot({
  par(mar=c(0,0,3,0))
  raster(TLC_MS_files()[[which(TLC_MS_files_name() == input$TLC_MS_calib_pict)]],
         main=paste0("Select (",TLC_MS_files_name()[which(TLC_MS_files_name() == input$TLC_MS_calib_pict)],")"),xlim=TLC_MS_zoom$x,ylim=TLC_MS_zoom$y)
  if(!is.null(TLC_MS_Validate_coord$x)){
    text(x=TLC_MS_Validate_coord$x*10,y=TLC_MS_Validate_coord$y*10,label="X",col="red")
    symbols(x=TLC_MS_Validate_coord$x*10,y=TLC_MS_Validate_coord$y*10,fg="red",inches = F,add = T,rectangles = cbind(input$TLC_MS_stamp_width*10,input$TLC_MS_stamp_height*10))
    
  }
})

output$TLC_MS_pict.1 <- renderPlot({
  validate(
    need(input$TLC_MS_validateSystem, "The system is not validated")
  )
  par(mar=c(0,0,3,0))
  raster(TLC_MS_files()[[1]],main=TLC_MS_files_name()[1],xlim=c(0,TLC_MS_x_width),ylim=c(0,TLC_MS_y_height))
  # if(!is.null(TLC_MS_coord$x)){
  #   text(x=TLC_MS_coord$x*10,y=TLC_MS_coord$y*10,label=seq(length(TLC_MS_coord$x)),col="red",pos = 3)
  #   symbols(x=TLC_MS_coord$x*10,y=TLC_MS_coord$y*10,fg="red",inches = F,add = T,rectangles = cbind(rep(input$TLC_MS_stamp_width*10,length(TLC_MS_coord$x)),rep(input$TLC_MS_stamp_height*10,length(TLC_MS_coord$x))))
  # }
})
output$TLC_MS_pict.1.zoom <- renderPlot({
  validate(
    need(input$TLC_MS_validateSystem, "The system is not validated")
  )
  par(mar=c(0,0,3,0))
  raster(TLC_MS_files()[[1]],main=TLC_MS_files_name()[1],xlim=TLC_MS_zoom$x,ylim=TLC_MS_zoom$y)
  if(!is.null(TLC_MS_coord$x)){
    text(x=TLC_MS_coord$x*10,y=TLC_MS_coord$y*10,label=seq(length(TLC_MS_coord$x)),col="red",pos = 3)
    symbols(x=TLC_MS_coord$x*10,y=TLC_MS_coord$y*10,fg="red",inches = F,add = T,rectangles = cbind(rep(input$TLC_MS_stamp_width*10,length(TLC_MS_coord$x)),rep(input$TLC_MS_stamp_height*10,length(TLC_MS_coord$x))))
  }
})
output$TLC_MS_pict.2 <- renderPlot({
  validate(
    need(input$TLC_MS_validateSystem, "The system is not validated")
  )
  validate(
    need(length(TLC_MS_files()) > 1, "Not enough pictures")
  )
  par(mar=c(0,0,3,0))
  raster(TLC_MS_files()[[2]],main=TLC_MS_files_name()[2],xlim=c(0,TLC_MS_x_width),ylim=c(0,TLC_MS_y_height))
  # if(!is.null(TLC_MS_coord$x)){
  #   text(x=TLC_MS_coord$x*10,y=TLC_MS_coord$y*10,label=seq(length(TLC_MS_coord$x)),col="red",pos = 3)
  #   symbols(x=TLC_MS_coord$x*10,y=TLC_MS_coord$y*10,fg="red",inches = F,add = T,rectangles = cbind(rep(input$TLC_MS_stamp_width*10,length(TLC_MS_coord$x)),rep(input$TLC_MS_stamp_height*10,length(TLC_MS_coord$x))))
  # }
})
output$TLC_MS_pict.2.zoom <- renderPlot({
  validate(
    need(input$TLC_MS_validateSystem, "The system is not validated")
  )
  validate(
    need(length(TLC_MS_files()) > 1, "Not enough pictures")
  )
  par(mar=c(0,0,3,0))
  raster(TLC_MS_files()[[2]],main=TLC_MS_files_name()[2],xlim=TLC_MS_zoom$x,ylim=TLC_MS_zoom$y)
  if(!is.null(TLC_MS_coord$x)){
    text(x=TLC_MS_coord$x*10,y=TLC_MS_coord$y*10,label=seq(length(TLC_MS_coord$x)),col="red",pos = 3)
    symbols(x=TLC_MS_coord$x*10,y=TLC_MS_coord$y*10,fg="red",inches = F,add = T,rectangles = cbind(rep(input$TLC_MS_stamp_width*10,length(TLC_MS_coord$x)),rep(input$TLC_MS_stamp_height*10,length(TLC_MS_coord$x))))
  }
})
output$TLC_MS_pict.3 <- renderPlot({
  validate(
    need(input$TLC_MS_validateSystem, "The system is not validated")
  )
  validate(
    need(length(TLC_MS_files()) > 2, "Not enough pictures")
  )
  par(mar=c(0,0,3,0))
  raster(TLC_MS_files()[[3]],main=TLC_MS_files_name()[3],xlim=c(0,TLC_MS_x_width),ylim=c(0,TLC_MS_y_height))
  # if(!is.null(TLC_MS_coord$x)){
  #   text(x=TLC_MS_coord$x*10,y=TLC_MS_coord$y*10,label=seq(length(TLC_MS_coord$x)),col="red",pos = 3)
  #   symbols(x=TLC_MS_coord$x*10,y=TLC_MS_coord$y*10,fg="red",inches = F,add = T,rectangles = cbind(rep(input$TLC_MS_stamp_width*10,length(TLC_MS_coord$x)),rep(input$TLC_MS_stamp_height*10,length(TLC_MS_coord$x))))
  # }
})
output$TLC_MS_pict.3.zoom <- renderPlot({
  validate(
    need(input$TLC_MS_validateSystem, "The system is not validated")
  )
  validate(
    need(length(TLC_MS_files()) > 2, "Not enough pictures")
  )
  par(mar=c(0,0,3,0))
  raster(TLC_MS_files()[[3]],main=TLC_MS_files_name()[3],xlim=TLC_MS_zoom$x,ylim=TLC_MS_zoom$y)
  if(!is.null(TLC_MS_coord$x)){
    text(x=TLC_MS_coord$x*10,y=TLC_MS_coord$y*10,label=seq(length(TLC_MS_coord$x)),col="red",pos = 3)
    symbols(x=TLC_MS_coord$x*10,y=TLC_MS_coord$y*10,fg="red",inches = F,add = T,rectangles = cbind(rep(input$TLC_MS_stamp_width*10,length(TLC_MS_coord$x)),rep(input$TLC_MS_stamp_height*10,length(TLC_MS_coord$x))))
  }
})
output$TLC_MS_pict.4 <- renderPlot({
  validate(
    need(input$TLC_MS_validateSystem, "The system is not validated")
  )
  validate(
    need(length(TLC_MS_files()) > 3, "Not enough pictures")
  )
  par(mar=c(0,0,3,0))
  raster(TLC_MS_files()[[4]],main=TLC_MS_files_name()[4],xlim=c(0,TLC_MS_x_width),ylim=c(0,TLC_MS_y_height))
  # if(!is.null(TLC_MS_coord$x)){
  #   text(x=TLC_MS_coord$x*10,y=TLC_MS_coord$y*10,label=seq(length(TLC_MS_coord$x)),col="red",pos = 3)
  #   symbols(x=TLC_MS_coord$x*10,y=TLC_MS_coord$y*10,fg="red",inches = F,add = T,rectangles = cbind(rep(input$TLC_MS_stamp_width*10,length(TLC_MS_coord$x)),rep(input$TLC_MS_stamp_height*10,length(TLC_MS_coord$x))))
  # }
})
output$TLC_MS_pict.4.zoom <- renderPlot({
  validate(
    need(input$TLC_MS_validateSystem, "The system is not validated")
  )
  validate(
    need(length(TLC_MS_files()) > 3, "Not enough pictures")
  )
  par(mar=c(0,0,3,0))
  raster(TLC_MS_files()[[4]],main=TLC_MS_files_name()[4],xlim=TLC_MS_zoom$x,ylim=TLC_MS_zoom$y)
  if(!is.null(TLC_MS_coord$x)){
    text(x=TLC_MS_coord$x*10,y=TLC_MS_coord$y*10,label=seq(length(TLC_MS_coord$x)),col="red",pos = 3)
    symbols(x=TLC_MS_coord$x*10,y=TLC_MS_coord$y*10,fg="red",inches = F,add = T,rectangles = cbind(rep(input$TLC_MS_stamp_width*10,length(TLC_MS_coord$x)),rep(input$TLC_MS_stamp_height*10,length(TLC_MS_coord$x))))
  }
})

TLC_MS_table.dim <- reactive({
  data <- data.frame(pictX = TLC_MS_coord$x, pictY = TLC_MS_coord$y)
  data$stamp = seq(nrow(data))
  data$x_mm = data$pictX# * x_resolution
  data$y_mm = data$pictY# * y_resolution
  # data$reverse_y = 100 - data$y
  data$Rt = rep(" ",nrow(data))
  data$mz_pos = rep(" ",nrow(data))
  data$mz_neg = rep(" ",nrow(data))
  data$remark = rep(" ",nrow(data))
  data[,3:ncol(data)]
})

output$TLC_MS_table <- renderTable({
  TLC_MS_table.dim()
})

## batch part
output$TLC_MS_batch_table <- renderTable({
  TLC_MS_table.dim()
})
TLC_MS_feedback = reactiveValues(text="no feedback yet",laser="off")
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

observeEvent(input$TLC_MS_laser,{
  # create the gcode
  if(TLC_MS_feedback$laser == "off"){
    python.call("GPIO7_on")
    TLC_MS_feedback$laser = "on"
  }else{
    python.call("GPIO7_off")
    TLC_MS_feedback$laser = "off"
  }
})

observeEvent(input$TLC_MS_batch_action,{
  for(i in unlist(strsplit(input$TLC_MS_batch_before,split = "\n"))){
    main$send_cmd(i)
    main$send_cmd("M400")
    main$send_cmd("G4 P100")
  }
  for(i in seq(length(TLC_MS_coord$x))){
    main$send_cmd("G90")# ; use absolute positioning for the XYZ axes
    main$send_cmd(paste0("G1 Z",TLC_MS_coord$y[i]," F200"))
    main$send_cmd(paste0("G1 E",TLC_MS_coord$x[i]," F2000"))
    main$send_cmd("M400")
    main$send_cmd("G4 P100")
    for(j in unlist(strsplit(input$TLC_MS_batch_between,split = "\n"))){
      if(j == "G4 P2000; insert numeric stamp time"){
        j = paste0("G4 P",input$TLC_MS_stamp_time,"; insert numeric stamp time")
      }
      main$send_cmd(j)
      main$send_cmd("M400")
      main$send_cmd("G4 P100")
    }
  }
  for(i in unlist(strsplit(input$TLC_MS_batch_after,split = "\n"))){
    main$send_cmd(i)
    main$send_cmd("M400")
    main$send_cmd("G4 P100")
  }
  TLC_MS_feedback$text = "batch finished"
})

observeEvent(input$TLC_MS_batch_action_init,{
  for(i in unlist(strsplit(input$TLC_MS_batch_before,split = "\n"))){
    main$send_cmd(i)
    main$send_cmd("M400")
    main$send_cmd("G4 P100")
  }
  TLC_MS_feedback$text = "init finished"
})

