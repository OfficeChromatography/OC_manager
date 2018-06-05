## server_TLC_MS for OC_manager
##
TLC_MS_x_width = 2000
TLC_MS_y_height = 1000

nogo = list(x=c(10,190),y=c(5,90))


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



# config_tlcms = read.csv("config_tlcms.ms")
# TLC_MS_x_bias = config_tlcms[,1]#4.5
# TLC_MS_y_bias = config_tlcms[,2]

output$TLC_MS_control_1 = renderUI({
  
  tabsetPanel(
    tabPanel("Input/output",
             sidebarLayout(
               sidebarPanel(width = 3,
                            fileInput("TLC_MS_fileInput",label = "picture(s) file(s)",multiple = T),
                            downloadButton("TLC_MS_down_csv","Download CSV"),
                            downloadButton("TLC_MS_down_gcode","Download gcode"),
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
                    textInput("TLC_MS_color","Color on plots","red"),
                    # numericInput("TLC_MS_x_bias","TLC_MS_x_bias",-5),
                    # numericInput("TLC_MS_y_bias","TLC_MS_y_bias",-5)
                    textInput("TLC_MS_profile_name","Profile name to save",""),
                    actionButton("TLC_MS_profile_save","Save profile"),
                    selectInput("TLC_MS_profiles","Profile name to load",choices = c("Default",dir("tlcms_profile/")))
             )
             
    )
  )
})

TLC_MS_manual = reactiveValues(LED=F,head=F,elution=F,
                               TLC_MS_x_bias=if(file.exists("config_tlcms.csv")){read.csv("config_tlcms.csv")[,1]}else{4},
                               TLC_MS_y_bias=if(file.exists("config_tlcms.csv")){read.csv("config_tlcms.csv")[,2]}else{1})

output$TLC_MS_control_manual = renderUI({
  
  tagList(
    column(4,
           if(!TLC_MS_manual$LED){actionButton("TLC_MS_manual_LED_on","LED on")}else{actionButton("TLC_MS_manual_LED_off","LED off")},hr(),
           if(!TLC_MS_manual$head){actionButton("TLC_MS_manual_head_down","Head down")}else{actionButton("TLC_MS_manual_head_up","Head up")},hr(),
           if(!TLC_MS_manual$head){actionButton("TLC_MS_manual_rinsing","Purge head")},hr(),
           if(TLC_MS_manual$elution){actionButton("TLC_MS_manual_Valve_bypass","Valve bypass")}else{actionButton("TLC_MS_manual_Valve_elution","Valve elution")},hr(),
           actionButton("TLC_MS_Home_X","Home X"),
           actionButton("TLC_MS_Home_YZ","Home Y and Home Z")
    ),
    column(4,
           uiOutput("TLC_MS_control_manual_2")
    ),
    column(4,
           uiOutput("TLC_MS_control_manual_3")
    )
  )
})

output$TLC_MS_control_manual_2 = renderUI({
  position = as.numeric(input$TLC_MS_manual_calib_selectize)
  tagList(numericInput("TLC_MS_x_bias","x bias",TLC_MS_manual$TLC_MS_x_bias),
          numericInput("TLC_MS_y_bias","y bias",TLC_MS_manual$TLC_MS_y_bias),
          verbatimTextOutput("TLC_MS_biases"),
          numericInput("TLC_MS_manual_go_X","X",if(length(TLC_MS_coord$x) == 0){100}else{TLC_MS_coord$x[position]}),
          numericInput("TLC_MS_manual_go_Y","Y",if(length(TLC_MS_coord$y) == 0){50}else{TLC_MS_coord$y[position]}),
          actionButton("TLC_MS_manual_go","Go (home first)"))
})
output$TLC_MS_control_manual_3 = renderUI({
  tagList(plotOutput("TLC_MS_manual_calib_plot",click = "TLC_MS_manual_calib_plot_click"),
          selectizeInput("TLC_MS_manual_calib_selectize","Select position",choices = seq_len(length(TLC_MS_coord$x))),#improve may be
          plotOutput("TLC_MS_manual_calib_raster"))
})
observeEvent(input$TLC_MS_manual_calib_selectize,{
  position = as.numeric(input$TLC_MS_manual_calib_selectize)
  updateNumericInput(session,"TLC_MS_manual_go_X",value = TLC_MS_coord$x[position])
  updateNumericInput(session,"TLC_MS_manual_go_Y",value = TLC_MS_coord$y[position])
})
output$TLC_MS_manual_calib_plot = renderPlot({
  # validate(length(TLC_MS_coord$x) >= 1,"Select at least one position")## need first point in the table selected to have a target
  position = as.numeric(input$TLC_MS_manual_calib_selectize)
  par(mar = c(0,0,2.5,0))
  plot(c(-2.5,2.5),c(-2.5,2.5),type="n",
       xlab="X (mm)",ylab="Y (mm)",xaxt="n",yaxt="n",
       main=paste0("Stamp ",position,":\ntarget X: ",TLC_MS_coord$x[position],
                   " - target Y: ",TLC_MS_coord$y[position])
  )
  text(y=c(-2,-1,1,2),x=rep(0,4),label=c("-1","-0.1","+0.1","+1"))
  text(x=c(-2,-1,1,2),y=rep(0,4),label=c("-1","-0.1","+0.1","+1"))
  symbols(y=c(-2,-1,1,2),x=rep(0,4),inches = F,add = T,rectangles = cbind(rep(0.8,4),rep(0.8,4)),lwd=2)
  symbols(x=c(-2,-1,1,2),y=rep(0,4),inches = F,add = T,rectangles = cbind(rep(0.8,4),rep(0.8,4)),lwd=2)
})
observeEvent(input$TLC_MS_manual_calib_plot_click,{
  x = round(input$TLC_MS_manual_calib_plot_click$x)
  y = round(input$TLC_MS_manual_calib_plot_click$y)
  if(y == 0){y = 0}else if(y > 0){y = - 10^(y-2)}else{y = 10^(abs(y)-2)}
  if(x == 0){x = 0}else if(x > 0){x = 10^(x-2)}else{x = - 10^(abs(x)-2)}
  updateNumericInput(session,"TLC_MS_x_bias","x bias",TLC_MS_manual$TLC_MS_x_bias+x)
  updateNumericInput(session,"TLC_MS_y_bias","y bias",TLC_MS_manual$TLC_MS_y_bias+y)
  if(connect$board){
    gcode = paste0("G1 X",input$TLC_MS_manual_go_X+TLC_MS_manual$TLC_MS_x_bias,
                   " Y",input$TLC_MS_manual_go_Y+TLC_MS_manual$TLC_MS_y_bias,
                   " Z",input$TLC_MS_manual_go_Y+TLC_MS_manual$TLC_MS_y_bias)
    test_ink_file = paste0("gcode/","test_ink",".gcode")
    Log = test_ink_file
    fileConn<-file(test_ink_file)
    writeLines(gcode, fileConn)
    close(fileConn)
    # send the gcode
    main$send_gcode(test_ink_file)
  }else{
    #     gcode = paste0("G1 X",input$TLC_MS_manual_go_X+TLC_MS_manual$TLC_MS_x_bias," Y",input$TLC_MS_manual_go_Y+TLC_MS_manual$TLC_MS_y_bias," Z",input$TLC_MS_manual_go_Y+TLC_MS_manual$TLC_MS_y_bias)
    #     print(gcode)
    shinyalert(title = "stupid user",text = "Board not connected",type="error",closeOnClickOutside = T, showCancelButton = F)
  }
})

observeEvent(input$TLC_MS_manual_go,{
  if(connect$board){
    gcode = paste0("G1 X",input$TLC_MS_manual_go_X+TLC_MS_manual$TLC_MS_x_bias,
                   " Y",input$TLC_MS_manual_go_Y+TLC_MS_manual$TLC_MS_y_bias,
                   " Z",input$TLC_MS_manual_go_Y+TLC_MS_manual$TLC_MS_y_bias)
    test_ink_file = paste0("gcode/","test_ink",".gcode")
    Log = test_ink_file
    fileConn<-file(test_ink_file)
    writeLines(gcode, fileConn)
    close(fileConn)
    # send the gcode
    main$send_gcode(test_ink_file)
  }else{
    # gcode = paste0("G1 X",input$TLC_MS_manual_go_X+TLC_MS_manual$TLC_MS_x_bias," Y",input$TLC_MS_manual_go_Y+TLC_MS_manual$TLC_MS_y_bias," Z",input$TLC_MS_manual_go_Y+TLC_MS_manual$TLC_MS_y_bias)
    # print(gcode)
    shinyalert(title = "stupid user",text = "Board not connected",type="error",closeOnClickOutside = T, showCancelButton = F)
  }
})

output$TLC_MS_biases = renderPrint({
  print(paste0("x: ",TLC_MS_manual$TLC_MS_x_bias," - y: ",TLC_MS_manual$TLC_MS_y_bias))
})
observeEvent(input$TLC_MS_y_bias,{
  TLC_MS_manual$TLC_MS_y_bias = input$TLC_MS_y_bias
  data = data.frame(TLC_MS_x_bias=input$TLC_MS_x_bias,TLC_MS_y_bias=input$TLC_MS_y_bias)
  write.csv(data,"config_tlcms.csv",row.names = F)
})
observeEvent(input$TLC_MS_x_bias,{
  TLC_MS_manual$TLC_MS_x_bias = input$TLC_MS_x_bias
  data = data.frame(TLC_MS_x_bias=input$TLC_MS_x_bias,TLC_MS_y_bias=input$TLC_MS_y_bias)
  write.csv(data,"config_tlcms.csv",row.names = F)
})
observeEvent(input$TLC_MS_profiles,{
  if(input$TLC_MS_profiles == "Default"){
    updateTextAreaInput(session,"TLC_MS_batch_before",value = TLC_MS_before)
    updateTextAreaInput(session,"TLC_MS_batch_between",value = TLC_MS_between)
    updateTextAreaInput(session,"TLC_MS_batch_after",value = TLC_MS_after)
    updateNumericInput(session,"TLC_MS_elution_time",value = 20000)
    updateNumericInput(session,"TLC_MS_rinsing_time",value = 20000)
  }else{
    load(paste0("tlcms_profile/",input$TLC_MS_profiles))
    updateTextAreaInput(session,"TLC_MS_batch_before",value = data$TLC_MS_before)
    updateTextAreaInput(session,"TLC_MS_batch_between",value = data$TLC_MS_between)
    updateTextAreaInput(session,"TLC_MS_batch_after",value = data$TLC_MS_after)
    if(length(data) > 3){
      updateNumericInput(session,"TLC_MS_elution_time",value = data$TLC_MS_elution_time)
      updateNumericInput(session,"TLC_MS_rinsing_time",value = data$TLC_MS_rinsing_time)
    }
  }
})
observeEvent(input$TLC_MS_profile_save,{
  data = list(
    TLC_MS_before = input$TLC_MS_batch_before,
    TLC_MS_between = input$TLC_MS_batch_between,
    TLC_MS_after = input$TLC_MS_batch_after,
    TLC_MS_elution_time = input$TLC_MS_elution_time,
    TLC_MS_rinsing_time = input$TLC_MS_rinsing_time
  )
  if(nchar(input$TLC_MS_profile_name) == 0){
    shinyalert(type="error",title="stupid user",text = "Give a name to the profile to save")
  }else{
    save(data,file=paste0("tlcms_profile/",input$TLC_MS_profile_name,".Rdata"))
    updateSelectInput(session,"TLC_MS_profiles",choices = c("Default",dir("tlcms_profile/")))
  }
  
})

observeEvent(input$TLC_MS_Home_X,{
  if(connect$board){
    main$send_gcode("gcode/TLC_MS_Home_X.gcode")
  }else{
    shinyalert(title = "stupid user",text = "Board not connected",type="error",closeOnClickOutside = T, showCancelButton = F)
  }
})
observeEvent(input$TLC_MS_Home_YZ,{
  if(connect$board){
    main$send_gcode("gcode/TLC_MS_Home_YZ.gcode")
  }else{
    shinyalert(title = "stupid user",text = "Board not connected",type="error",closeOnClickOutside = T, showCancelButton = F)
  }
})
observeEvent(input$TLC_MS_manual_LED_on,{
  validate(need(connect$login,"Please login"))
  main$send_gcode("gcode/TLC_MS_LED_on.gcode")
  TLC_MS_manual$LED = T
})

observeEvent(input$TLC_MS_manual_LED_off,{
  validate(need(connect$login,"Please login"))
  main$send_gcode("gcode/TLC_MS_LED_off.gcode")
  TLC_MS_manual$LED = F
})

observeEvent(input$TLC_MS_manual_head_down,{
  validate(need(connect$login,"Please login"))
  main$send_gcode("gcode/TLC_MS_head_down.gcode")
  TLC_MS_manual$head = T
})

observeEvent(input$TLC_MS_manual_head_up,{
  validate(need(connect$login,"Please login"))
  main$send_gcode("gcode/TLC_MS_head_up.gcode")
  TLC_MS_manual$head = F
})
observeEvent(input$TLC_MS_manual_Valve_bypass,{
  validate(need(connect$login,"Please login"))
  main$send_gcode("gcode/TLC_MS_valve_bypass.gcode")
  TLC_MS_manual$elution = F
})

observeEvent(input$TLC_MS_manual_Valve_elution,{
  validate(need(connect$login,"Please login"))
  main$send_gcode("gcode/TLC_MS_valve_elution.gcode")
  TLC_MS_manual$elution = T
})

observeEvent(input$TLC_MS_manual_rinsing,{
  validate(need(!TLC_MS_manual$head,"Head down"),
           need(connect$login,"Please login"))
  main$send_gcode("gcode/TLC_MS_manual_rinsing.gcode")
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
  if(x < nogo$x[1] | x > nogo$x[2] | y < nogo$y[1] | y > nogo$y[2]){
    shinyalert(type="error",title="stupid user",text = paste0("Do not click in the no go zone: x < ",nogo$x[1]," | x > ",nogo$x[2]," | y < ",nogo$y[1]," | y > ",nogo$y[2]))
  }else{
    TLC_MS_coord$x <- c(TLC_MS_coord$x,x)
    TLC_MS_coord$y <- c(TLC_MS_coord$y,y)
  }
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
    if(i == 1){
      gcode = c(gcode,"G1 Z0.25 Y0.25;compensate Y backslash")
    }else if(TLC_MS_coord$y[i] < TLC_MS_coord$y[i-1]){
      gcode = c(gcode,"G1 Z0.25 Y0.25;compensate Y backslash")
    }
    gcode = c(gcode,paste0("G1 Z",TLC_MS_coord$y[i]+TLC_MS_manual$TLC_MS_y_bias," Y",TLC_MS_coord$y[i]+TLC_MS_manual$TLC_MS_y_bias))
    gcode = c(gcode,paste0("G1 X",TLC_MS_coord$x[i]+TLC_MS_manual$TLC_MS_x_bias))
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
  if(connect$board){
    # create the gcode
    Method_file = paste0("gcode/","Method",".gcode")
    Log = Method_file
    fileConn<-file(Method_file)
    writeLines(TLC_MS_gcode(), fileConn)
    close(fileConn)
    # put it in the log
    write(paste0(format(Sys.time(),"%Y%m%d_%H:%M:%S"),";","TLC_MS",";",Log,";",Log,";",connect$Visa,";",input$Plate),file="log/log.txt",append = T)
    # send the gcode
    main$send_gcode(Method_file)
    TLC_MS_feedback$text = "batch finished"
  }else{
    shinyalert(title = "stupid user",text = "Board not connected",type="error",closeOnClickOutside = T, showCancelButton = F)
  }
  
  
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


output$TLC_MS_down_csv = downloadHandler(
  filename = "TLCMS.csv",
  content = function(file) {
    write.csv(TLC_MS_table.dim(),file="TLCMS.csv",sep = ",")
    file.copy("TLCMS.csv", file)
  }
)

output$TLC_MS_down_gcode <- downloadHandler(
  filename = "OC_manager.gcode",
  content = function(file) {
    Method_file = paste0("gcode/","Method",".gcode")
    Log = Method_file
    fileConn<-file(Method_file)
    writeLines(TLC_MS_gcode(), fileConn)
    close(fileConn)
    file.copy(paste0("gcode/","Method",".gcode"), file)
  }
)