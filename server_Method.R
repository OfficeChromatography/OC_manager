## server_Method.R

source("eat_table.R")
output$Method_control_1 = renderUI({
  tagList(
    fluidPage(fluidRow(
           column(2,selectizeInput("Method_step_new","Select new step",choices = steps_choices)),
           actionButton("Method_step_add","",icon=icon("plus")),
           actionButton("Method_step_delete","",icon = icon("window-close")),
           actionButton("Method_step_exec","",icon = icon("play")),
           actionButton("Method_step_stop","",icon = icon("stop")),
           column(2,textInput("Method_save_name","Method name to save","Sandbox")),actionButton("Method_save","",icon=icon("save")),
           column(2,uiOutput("Method_load_names")),actionButton("Method_load","",icon=icon("folder-o")),actionButton("Method_load_refresh","",icon=icon("refresh")),
           actionButton("Method_step_home","",icon = icon("home")),
           actionButton("Method_step_parking","",icon = icon("eyedropper")),
           actionButton("Method_nozzle_test","",icon = icon("heartbeat")),
           actionButton("Method_DART_parking","",icon = icon("reply-all")),
           column(2,textOutput("Method_feedback")),
           bsTooltip("Method_step_add","add step"),
           bsTooltip("Method_step_delete","delete step"),
           bsTooltip("Method_step_exec","Execute step, method will be saved"),
           bsTooltip("Method_step_stop","Emergency stop, not on windows"),
           bsTooltip("Method_save","Save the method, carefull to overwritte"),
           bsTooltip("Method_load_refresh","Refresh list of method names"),
           bsTooltip("Method_load","Load saved method"),
           bsTooltip("Method_step_home","Go in home position"),
           bsTooltip("Method_step_parking","For the inkjet, send the cartridge in parking position, go home first or you will break the machine"),
           bsTooltip("Method_nozzle_test","test the nozzles with a paper, go home first or you will break the machine"),
           bsTooltip("Method_DART_parking","For the DART, send the plate in parking position, go home first or you will break the machine")
    )),
    column(2,
           # uiOutput("Method_control_4"),
           uiOutput("Method_control_2")
           ),
    uiOutput("Method_control_3"),
    uiOutput("Method_control_5")
    )
})


output$Method_feedback = renderText({
  Method_feedback$text
})
Method_feedback = reactiveValues(text="no feedback yet")

output$Method_control_2 = renderUI({
  validate(
    need(length(Method$l) > 0 ,"add a step or load a saved method")
  )
  input$Method_step_add
  truc = seq(length(Method$l))
  names(truc) = paste0("Step ",seq(length(Method$l)),": ",lapply(Method$l,function(x){x$type}))
  radioButtons("Method_steps","Steps",choices = truc,selected = Method$selected)
})
output$Method_control_3 = renderUI({
  validate(
    need(length(Method$l) > 0 ,"add a step or load a saved method")
  )
  if(!is.null(input$Method_steps)){
    if(Method$l[[as.numeric(input$Method_steps)]]$type %in% need_appli){
      tagList(
        column(5,
               actionButton("Method_step_update","Update step",icon=icon("gears")),
               downloadButton("Method_gcode_download","Download Gcode"),
               rHandsontableOutput("Method_step_option")
        ),
        column(5,
               rHandsontableOutput("Method_step_appli_table"),
               verbatimTextOutput("Method_step_feedback")
        )
        
      )
    }else{
      tagList(
        column(5,
               actionButton("Method_step_update","Update step",icon=icon("gears")),
               downloadButton("Method_gcode_download","Download Gcode"),
               rHandsontableOutput("Method_step_option"),
               verbatimTextOutput("Method_step_feedback")
        ),
        column(5,
               plotOutput("Method_plot",width="400px",height="400px")
               )
        
      )
    }
  }
})
output$Method_control_4 = renderUI({
  validate(
    need(!board,"not in DPE"),
    need(connect$board,"Please connect the board")
  )
  # TempInvalidate() ## called in server.R to invalidate every 2 secondes
  # full = python.call("get_temp")
  # full = gsub(pattern = "ok T:499.5 /0.0 B:",x = full,replacement = "Bed temp: ")
  # full = gsub(pattern = "T0:499.5 /0.0 @:0 B@:0 ",x = full,replacement = "°C")
  tagList(
    h6("no temp")
  )
})
output$Method_control_5 = renderUI({
  validate(
    need(length(Method$l) > 0 ,"add a step or load a saved method")
  )
  if(!is.null(input$Method_steps)){
    if(Method$l[[as.numeric(input$Method_steps)]]$type %in% need_appli){
      tagList(
        column(12,
               column(6,DT::dataTableOutput("Method_gcode")),
               column(6,plotOutput("Method_plot",width="400px",height="400px"))
        )
      )
    }else{
      DT::dataTableOutput("Method_gcode")
    }
  }
})
output$Method_load_names = renderUI({
  input$Method_load_refresh
  selectizeInput("Method_load_name","Method name to load",choices=dir("methods/"))
})

Method = reactiveValues(l=list(),selected = 1)

observeEvent(input$Method_step_add,{
  data = read.table(paste0("tables/",input$Method_step_new,"_table.csv"),header=T,sep=";")
  Method$l[[length(Method$l)+1]] = list(type=input$Method_step_new,
                                        table=data,
                                        eat_table = eat_table[[input$Method_step_new]],
                                        gcode = NULL,
                                        plot=function(){plot(x=1,y=1,type="n",main="Update to visualize")},
                                        info = "update to see the info",
                                        Done = F)
  if(input$Method_step_new %in% need_appli){
    nbr_band=data[data[,1] == "nbr_band",2]
    Method$l[[length(Method$l)]]$appli_table = data.frame(Band = seq(nbr_band),Vial = rep(1,nbr_band),Repeat = rep(1,nbr_band),I = rep(10,nbr_band),Content = rep("water",nbr_band),Use = rep(T,nbr_band))
    Method$l[[length(Method$l)]]$appli_table$Content = as.character(Method$l[[length(Method$l)]]$appli_table$Content)
  }
  Method_feedback$text = paste0("Step ",input$Method_step_new," added")
  Method$selected = length(Method$l)
})
observeEvent(input$Method_step_delete,{
  Method_feedback$text = paste0("Step ",input$Method_steps," deleted")
  Method$l[[as.numeric(input$Method_steps)]] = NULL
  Method$selected = 1
})

observeEvent(input$Method_step_update,{
  data = hot_to_r(input$Method_step_option)
  Method$l[[as.numeric(input$Method_steps)]]$table=data
  ## update SA_table if appicable
  if(Method$l[[as.numeric(input$Method_steps)]]$type %in% need_appli){
    appli_data = hot_to_r(input$Method_step_appli_table)
    nbr_band = data[data[,1] == "nbr_band",2]
    if(nbr_band != nrow(appli_data)){ ## make a new one if applicable
      appli_data = data.frame(Band = seq(nbr_band),Vial = rep(1,nbr_band),Repeat = rep(1,nbr_band),I = rep(10,nbr_band),Content = rep("water",nbr_band),Use = rep(T,nbr_band))
    }
    Method$l[[as.numeric(input$Method_steps)]]$appli_table=appli_data
    Method$l[[length(Method$l)]]$appli_table$Content = as.character(Method$l[[length(Method$l)]]$appli_table$Content) ## coercion. 
  }
  
  ## eat tables
  withProgress(message = "Processing", value=0, { ## do not work well, don't know why
    Method$l[[as.numeric(input$Method_steps)]] = Method$l[[as.numeric(input$Method_steps)]]$eat_table(Method$l[[as.numeric(input$Method_steps)]])
  })
  Method$selected = input$Method_steps
  Method_feedback$text = paste0("Step ",input$Method_steps," updated")
  Method$l[[length(Method$l)]]$appli_table$Content = as.character(Method$l[[length(Method$l)]]$appli_table$Content) ## coercion. 
})

output$Method_step_option = renderRHandsontable({
  validate(
    need(length(Method$l) > 0 ,"add a step or load a saved method")
  )
  data = Method$l[[as.numeric(input$Method_steps)]]$table
  data$Value = as.numeric(data$Value)
  rhandsontable(data, rowHeaderWidth = 200) %>%
    hot_context_menu(allowRowEdit = FALSE, allowColEdit = FALSE) %>%
    hot_col("Option", readOnly = TRUE)
})
output$Method_step_appli_table = renderRHandsontable({
  data = Method$l[[as.numeric(input$Method_steps)]]$appli_table
  rhandsontable(data)
})

observeEvent(input$Method_save,{
  withProgress(message = "Processing", value=0, {
    l = Method$l
    save(l,file=paste0("methods/",input$Method_save_name,".Rdata"))
    Method_feedback$text = paste0("Method ",input$Method_save_name," saved")
  })
})
observeEvent(input$Method_load,{
  withProgress(message = "Processing", value=0, {
    load(paste0("methods/",input$Method_load_name))
    Method$l = l
    Method$selected = 1
    Method_feedback$text = paste0("Method ",input$Method_load_name," loaded")
    updateTextInput(session, "Method_save_name", value = gsub(pattern = ".Rdata",replacement = "",x = input$Method_load_name))
  })
})

output$Method_plot = renderPlot({
  validate(
    need(length(Method$l) > 0 ,"add a step or load a saved method")
  )
  if(!is.null(input$Method_steps)){
    Method$l[[as.numeric(input$Method_steps)]]$plot()
    if(!is.null(input$Chrom_upload)){
      rasterImage(f.read.image(input$Chrom_upload$datapath),xleft = 0,xright = 100,ybottom = 0,ytop = 100)
      par(new=T)
      Method$l[[as.numeric(input$Method_steps)]]$plot()
    } 
  }
})
output$Method_step_feedback = renderText({
  validate(
    need(length(Method$l) > 0 ,"add a step or load a saved method")
  )
  Method$l[[as.numeric(input$Method_steps)]]$info
})

output$Method_gcode = DT::renderDataTable({
  validate(
    need(length(Method$l) > 0 ,"add a step or load a saved method")
  )
  if(!is.null(input$Method_steps)){
    data.frame(gcode = Method$l[[as.numeric(input$Method_steps)]]$gcode)
  }
}, options = list(pageLength = 10))

## part for emergency stop
rv <- reactiveValues(
  id=list()
)
observeEvent(input$Method_step_exec,{
  if(board){ ## when no arduino connected, just testing
    if(!is.null(rv$id$pid)) return()
    write(paste0(format(Sys.time(),"%Y%m%d_%H:%M:%S"),";",Method$l[[as.numeric(input$Method_steps)]]$type,";Methods",";","Log",";",connect$Visa,";",input$Plate),file="log/log.txt",append = T)
    rv$id <- mcparallel({ main$test_stop()}) #
    Method_feedback$text = paste0("Step ",input$Method_steps," started. Process ",rv$id$pid)
  }else{
    # create the gcode
    # Method_file = paste0("gcode/",format(Sys.time(),"%Y%m%d_%H:%M:%S"),"Method",".gcode")
    Method_file = paste0("gcode/","Method",".gcode")
    Log = Method_file
    fileConn<-file(Method_file)
    writeLines(Method$l[[as.numeric(input$Method_steps)]]$gcode, fileConn)
    close(fileConn)
    # put it in the log
    write(paste0(format(Sys.time(),"%Y%m%d_%H:%M:%S"),";",Method$l[[as.numeric(input$Method_steps)]]$type,";",Log,";",Log,";",connect$Visa,";",input$Plate),file="log/log.txt",append = T)
    # send the gcode
    # if(!is.null(rv$id$pid)) return()
    if(input$Serial_windows){
      main$send_gcode(Method_file)
    }else{
      rv$id <- mcparallel({ main$send_gcode(Method_file)}) #python.call("test_stop")
    }
    
    Method_feedback$text = paste0("Step ",input$Method_steps," started. Process ",rv$id$pid)
  }
  
})
output$Method_gcode_download <- downloadHandler(
  filename = function(x){paste0("OC_manager_",
                                Method$l[[as.numeric(input$Method_steps)]]$type,
                                "_",
                                paste0(Method$l[[as.numeric(input$Method_steps)]]$table[,2],collapse = "_"),
                                '.gcode')},##"OC_manager.gcode",
  content = function(file) {
    Method_file = paste0("gcode/","Method",".gcode")
    Log = Method_file
    fileConn<-file(Method_file)
    writeLines(Method$l[[as.numeric(input$Method_steps)]]$gcode, fileConn)
    close(fileConn)
    file.copy(paste0("gcode/","Method",".gcode"), file)
  }
)
observeEvent(input$Method_step_stop,{
  validate(need(!input$Serial_windows,"not on windows"))
  if(!is.null(rv$id$pid)){
    tools::pskill(rv$id$pid)
    Method_feedback$text = paste0("Step ",input$Method_steps," stoped. Process ",rv$id$pid," killed")
    rv$id <- list()
    # put it in the log
    write(paste0(format(Sys.time(),"%Y%m%d_%H:%M:%S"),";",Method$l[[as.numeric(input$Method_steps)]]$type,";","Emergency stop","; LOG",";",connect$Visa,";",input$Plate),file="log/log.txt",append = T)
  }
})
observeEvent(input$Method_step_home,{
  # create the gcode
  test_ink_file = "gcode/test_ink_cmd.gcode"
  Log = test_ink_file
  fileConn<-file(test_ink_file)
  writeLines("G28 Y0", fileConn)
  close(fileConn)  # send the gcode
  main$send_gcode(test_ink_file)
  test_ink_file = "gcode/test_ink_cmd.gcode"
  Log = test_ink_file
  fileConn<-file(test_ink_file)
  writeLines("G28 X0", fileConn)
  close(fileConn)  # send the gcode
  main$send_gcode(test_ink_file)
})
observeEvent(input$Method_step_parking,{
  # create the gcode
  test_ink_file = "gcode/test_ink_cmd.gcode"
  Log = test_ink_file
  fileConn<-file(test_ink_file)
  writeLines("G1 X 130", fileConn)
  close(fileConn)  # send the gcode
  main$send_gcode(test_ink_file)
})
observeEvent(input$Method_DART_parking,{
  # create the gcode
  test_ink_file = "gcode/test_ink_cmd.gcode"
  Log = test_ink_file
  fileConn<-file(test_ink_file)
  writeLines("G1 Y 100 F3600", fileConn)
  close(fileConn)  # send the gcode
  main$send_gcode(test_ink_file)
})
observeEvent(input$Method_nozzle_test,{
  I = 20 ; L = 5## cahnge here to input different pulse and I
  gcode = c("G91",paste0("M700 P0 I",I," L",L," S",4095)) 
  for(i in seq(12)){
    S=rep(0,12);S[i] = 1;S = BinToDec(S)
    for(j in seq(10)){gcode = c(gcode,paste0("G1 X",0.25),"M400",paste0("M700 P0 I",I," L",L," S",S))}
  }
  gcode = c(gcode,paste0("G1 X",2),"M400",paste0("M700 P0 I",I," L",L," S",4095))
  gcode = c(gcode,"G90","M84")
  test_ink_file = paste0("gcode/","test_ink",".gcode")
  Log = test_ink_file
  fileConn<-file(test_ink_file)
  writeLines(gcode, fileConn)
  close(fileConn)
  # send the gcode
  main$send_gcode(test_ink_file)
  
})

# observe({
#   invalidateLater(1000, session)
#   if(!is.null(rv$id$pid)){
#     res <- mccollect(rv$id,wait=F)
#     if(is.null(res)){
#       Method_feedback$text <- sprintf("%1$s in process. Press stop to kill it",rv$id$pid)
#     }else{
#       Method_feedback$text <- jsonlite::toJSON(res)
#       rv$id <- list()
#     }
#   }
# })