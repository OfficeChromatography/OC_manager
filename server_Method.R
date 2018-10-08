## server_Method.R

output$Method_control_1 = renderUI({
  tagList(
    fluidPage(
    column(3,box(title = "Methods", width = "25%", height = 350,solidHeader = TRUE,status = "primary",
        fluidRow(
        column(1, actionButton("Method_step_add","",icon=icon("plus"))),
        column(1,offset=1,actionButton("Method_step_delete","",icon = icon("window-close")))),
        fluidRow(column(10,ofsett=1,selectizeInput("Method_step_new","",choices = steps_choices, width = "100%"))),
        fluidRow(
        sidebarPanel( id = "Steps",style = "overflow-y:scroll; height: 175px; position:relative; ", width = 12,
          uiOutput("Method_control_methods")))
        ),
    box( title = "Save & Load",width = "15%", height = "10%",solidHeader = TRUE,status = "primary",
         fluidRow(    
         column(9,textInput("Method_save_name","Saving name","Sandbox", width = "100%")),
             column(1,actionButton("Method_save","",icon=icon("save")))
         ),
         fluidRow(
             column(9,uiOutput("Method_load_names", width = "100%")),
             column(1,actionButton("Method_load","",icon=icon("folder-o")))
        )),
    box(title = "Start", width = "15%", height = "10%",solidHeader = TRUE,status = "primary",
        column(1,actionButton("Method_step_exec","",icon = icon("play")))
        ),
    box( width = "15%",status = "warning",
         uiOutput("Method_feedback")),
    box(title = "Gcode viewer", width = "15%",solidHeader = TRUE,status = "primary",
        uiOutput("Method_control_gcode"))
    ),
    column(9,
    box(title = "Settings", width = "85%", height = "45%",status = "warning",
      uiOutput("Method_control_settings")),
    box(title = "Information", width = "85%", height = "45%",status = "warning",
      uiOutput("Method_control_infos"))
  )
  )
  )
})

#-----------------------------------------------------------------------------------
# function
#-------------------------------------------------------------------------------------
##Variable
steps_choices = dir("tables/",pattern=".csv") %>% gsub(x=.,pattern=".csv",replacement="")
Method = reactiveValues(control=list(),settings=list(),selected = 1)
Method_feedback = reactiveValues(text="No feedback yet")
#-----------------------------------------------------------------------------------------

## methods

output$Method_control_methods = renderUI({
  validate(
    need(length(Method$settings) > 0 ,"Add a step or load a saved method")
  )
  # input$Method_step_add
  truc = seq(length(Method$settings))
  names(truc) = paste0("Step ",seq(length(Method$settings)),": ",lapply(Method$settings,function(x){x$type}))
  radioButtons("Method_steps","Steps:",choices = truc,selected = Method$selected)
})

observeEvent(input$Method_step_add,{
  step = length(Method$control)+1
  data = read.table(paste0("tables/",input$Method_step_new,".csv"),header=T,sep=";")
  Method$control[[step]] = list(type=input$Method_step_new,
                                table=data,                          
                                gcode = NULL,
                                info = "Update to see the info",
                                Done = F)
  Method$settings[[step]]=list(type=input$Method_step_new,
                               table=data)
  if(input$Method_step_new == "Documentation"){ ## pict table, special for Documentation
    nbr_pict=data[data[,1] == "nbr_pict",2]
    Method$control[[step]]$exec = source("eat_tables/Documentation_exec.R")$value
  }
  Method_feedback$text = paste0("Step ",input$Method_step_new," added")
  Method$selected = length(Method$control)
})

observeEvent(input$Method_step_delete,{
  if(length(Method$control) == 0){
    shinyalert(title = "stupid user",text = "no step to delete",type="error",closeOnClickOutside = T, showCancelButton = F)
  }else{
    Method_feedback$text = paste0("Step ",input$Method_steps," deleted")
    Method$control[[as.numeric(input$Method_steps)]] = NULL
    Method$settings[[as.numeric(input$Method_steps)]] = NULL
    Method$selected = 1
  }
  
})

observeEvent(input$Method_steps,{
  step <- as.numeric(input$Method_steps)
  if(step > 0){
    path=paste0("eat_tables/",Method$control[[step]]$type,".R")
    source(path)
    Method$control[[step]]$appli_table=appli_Table(Method$control[[step]])
    Method$settings[[step]]$appli_table=Method$control[[step]]$appli_table
    Method$control[[step]]$gcode=generate_gcode(Method$control[[step]])
  }
})



## feedback

output$Method_feedback = renderText({
  Method_feedback$text
})

## start

observeEvent(input$Method_step_exec,{
  step = as.numeric(input$Method_steps)
  if(Method$control[[step]]$type != "Documentation"){
      # read the gcode
      Method_file = paste0("gcode/","Method",".gcode")
      Log = Method_file
      fileConn<-file(Method_file)
      writeLines(Method$control[[step]]$gcode, fileConn)
      close(fileConn)
      # put it in the log
      write(paste0(format(Sys.time(),"%Y%m%d_%H:%M:%S"),";",Method$control[[step]]$type,";",Log,";",Log,";",connect$Visa,";",input$Plate),file="log/log.txt",append = T)
      gcode_sender$send_gcode(Method_file, printer)
	
      Method_feedback$text = paste0("Step ",input$Method_steps," started")
    }else{
      Method$control[[step]]$exec(Method$control[[step]],input$Plate,main)
    }
})



## gcode viewer
output$Method_control_gcode = renderUI({
  validate(
    need(length(Method$control) > 0 ,"Add a step or load a saved method")
  )
  if(!is.null(input$Method_steps)){
    tagList(
      fluidPage(
        fluidRow(downloadButton("Method_gcode_download","Download Gcode"))
      )
    )
  }
})


output$Method_gcode_download <- downloadHandler(
  filename = function(x){paste0("OC_Lab_",
                                Method$control[[as.numeric(input$Method_steps)]]$type,
                                "_",
                                paste0(Method$control[[as.numeric(input$Method_steps)]]$table[,2],collapse = "_"),
                                '.gcode')},##"OC_manager.gcode",
  content = function(file) {
    Method_file = paste0("gcode/","Method",".gcode")
    Log = Method_file
    fileConn<-file(Method_file)
    writeLines(Method$control[[as.numeric(input$Method_steps)]]$gcode, fileConn)
    close(fileConn)
    file.copy(paste0("gcode/","Method",".gcode"), file)
  }
)
## save

observeEvent(input$Method_save,{
  if(paste0(input$Method_save_name,".Rdata") %in% dir("methods/")){
    shinyalert(title = "Method exist",text = "Overwrite",type="warning",closeOnClickOutside = T, showCancelButton = T,
               callbackR = function(x){
                 if(x != FALSE){
                   withProgress(message = "Processing", value=0, {
                     settings = Method$settings
                     save(settings,file=paste0("methods/",input$Method_save_name,".Rdata"))
                     Method_feedback$text = paste0("Method ",input$Method_save_name," saved")
                   })
                   updateSelectizeInput(session,"Method_load_name",choices=dir("methods/"))
                 }else{
                   Method_feedback$text = paste0("Method ","not"," saved")
                 }
               })
  }else{
    withProgress(message = "Processing", value=0, {
      settings = Method$settings
      save(settings,file=paste0("methods/",input$Method_save_name,".Rdata"))
      Method_feedback$text = paste0("Method ",input$Method_save_name," saved")
    })
    updateSelectizeInput(session,"Method_load_name",choices=dir("methods/"))
  }
  
})
observeEvent(input$Method_load,{
  withProgress(message = "Processing", value=0, {
    load(paste0("methods/",input$Method_load_name))
    if(sum(unlist(lapply(settings,function(x){if(!(x$type %in% steps_choices)){return(T)}else{return(F)}}))) != 0){
      shinyalert(title = "Warning",text = "Old method, update may not work",type="warning",closeOnClickOutside = T, showCancelButton = F)
    }
    Method$settings = settings
    for (step in 1:length(settings)){
      print(step)
      Method$control[[step]] = list(type= Method$settings[[step]]$type,
                            table=Method$settings[[step]]$table,
			    appli_table=Method$settings[[step]]$appli_table,
                            gcode = NULL,
                            info = "Update to see the info",
                            Done = F)
    }
    Method$selected = 1
    Method_feedback$text = paste0("Method ",input$Method_load_name," loaded")
    updateTextInput(session, "Method_save_name", value = gsub(pattern = ".Rdata",replacement = "",x = input$Method_load_name))
  })
})

output$Method_load_names = renderUI({
  selectizeInput("Method_load_name","Method to load",choices=dir("methods/"))
})  
## settings

output$Method_control_settings = renderUI({
  validate(
    need(length(Method$control) > 0 ,"Add a step or load a saved method")
  )
  if(!is.null(input$Method_steps)){
    tagList(
      fluidPage(
        fluidRow(
          column(6, rHandsontableOutput("Method_step_option")),
          column(6,
                 rHandsontableOutput("Method_step_appli_table")),
          fluidRow(
            column(5,offset=7, actionButton("Method_step_update","Update settings",icon=icon("gears"))))
          
        )
      )
    )
  }
})

observeEvent(input$Method_step_update,{
  step = as.numeric(input$Method_steps)
  #update Settings
  data = hot_to_r(input$Method_step_option)
  Method$settings[[step]]$table=data
  Method$control[[step]]$table=data
  #update applied table 
  data=hot_to_r(input$Method_step_appli_table)
  Method$settings[[step]]$appli_table=data
  Method$control[[step]]$appli_table=data
  ## eat tables
  ## evaluateSelectedStep(steps)
  ## if type == Sample then sample$
  ##  myFunction = source(myFunction.R)
  ##
  withProgress(message = "Processing", value=0, { 
    path=paste0("eat_tables/",Method$control[[step]]$type,".R")
    source(path)
    Method$control[[step]]$appli_table=appli_Table(Method$control[[step]])
    Method$control[[step]]$gcode=generate_gcode(Method$control[[step]])
    
  })
  Method$selected = input$Method_steps
  Method_feedback$text = paste0("Step ",input$Method_steps," updated")
})

output$Method_step_option = renderRHandsontable({
  validate(
    need(length(Method$control) > 0 ,"add a step or load a saved method")
  )
  data = Method$control[[as.numeric(input$Method_steps)]]$table
  data$Value = as.numeric(data$Value)
  rhandsontable(data)
})

output$Method_step_appli_table = renderRHandsontable({
  if(!is.null(input$Method_steps)){
  data = Method$control[[as.numeric(input$Method_steps)]]$appli_table
  rhandsontable(data)%>%
    hot_col("Vol_real", readOnly = TRUE)%>%
    hot_col("unit", readOnly = TRUE)
  }
})


## information

output$Method_control_infos = renderUI({
  validate(
    need(length(Method$control) > 0 ,"Add a step or load a saved method")
  )
  if(!is.null(input$Method_steps)){
    tagList(
      column(12,
        plotOutput("Method_plot",width="400px",height="400px"))
    )
  }
})


output$Method_plot = renderPlot({
  validate(
    need(length(Method$control) > 0 ,"add a step or load a saved method")
  )
  if(!is.null(input$Method_steps)){
    step = as.numeric(input$Method_steps)
    path=paste0("eat_tables/",Method$control[[step]]$type,".R")
    source(path)
    plot_step(Method$control[[step]])
    
  }
  else
  {
    plot(x=1,y=1,type="n",main="Update to visualize")
  }
})
output$Method_step_feedback = renderText({
  validate(
    need(length(Method$control) > 0 ,"add a step or load a saved method")
  )
  Method$control[[as.numeric(input$Method_steps)]]$info
})


  





