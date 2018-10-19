
output$Method_control_1 = renderUI({
  tagList(
    fluidPage(
    column(3,box(title = "Methods", width = "25%", height = 350,solidHeader = TRUE,status = "primary",
        fluidRow(
        column(1, actionButton("Method_step_add","",icon=icon("plus"))),
        column(1,offset=1,actionButton("Method_step_delete","",icon = icon("window-close")))),
        fluidRow(column(10,ofsett=1,selectizeInput("Method_step_new","",choices = c("Sample Application"), width = "100%"))),
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


output$Method_control_methods = renderUI({
  validate(
    need(length(Method$control) > 0 ,"Add a step or load a saved method")
  )
  # input$Method_step_add
  truc = seq(length(Method$control))
  names(truc) = paste0("Step ",truc,": ",lapply(Method$control,function(x){x$type}))
  radioButtons("Method_steps","Steps:",choices = truc,selected = Method$selected)
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

## settings
output$Method_control_settings = renderUI({

    print("render ui")
    validate(
    need(length(Method$control) > 0 ,"Add a step or load a saved method")
    )

  if(!is.null(input$Method_steps)){
    tagList(
      fluidPage(
        fluidRow(
          column(6, rHandsontableOutput("printer_head_config")),
          column(6, rHandsontableOutput("plate_config")),
          fluidRow(
            column(5,offset=7, actionButton("Method_step_update","Update settings",icon=icon("gears"))))
          
        )
      )
    )
  }
})


## information
output$Method_control_infos = renderUI({
  validate(
    need(length(Method$control) > 0 ,"Add a step or load a saved method")
  )
  if(!is.null(input$Method_steps)){
    tagList(
        column(6, plotOutput("Method_plot",width="400px",height="400px")),
        column(6, rHandsontableOutput("band_config"))
    )
  }
})

output$Method_plot = renderPlot({
  #validate(
  #  need(length(Method$control) > 0 ,"add a step or load a saved method")
  #)
  #if(!is.null(input$Method_steps)){
  #  step = as.numeric(input$Method_steps)
  #  path=paste0("eat_tables/",Method$control[[step]]$type,".R")
  #  source(path)
  #  plot_step(Method$control[[step]])
    
  #}
  #else
  #{
  #  plot(x=1,y=1,type="n",main="Update to visualize")
  #}
})
output$Method_step_feedback = renderText({
  validate(
    need(length(Method$control) > 0 ,"add a step or load a saved method")
  )
  Method$control[[as.numeric(input$Method_steps)]]$info
})

output$printer_head_config = renderRHandsontable({
  validate(
    need(length(Method$control) > 0 ,"Please add a new step (for example: Sample Application)")
  )
  index = as.numeric(input$Method_steps)
  config = Method$control[[index]]$printer_head_config
  rhandsontable(t(data.frame(config)), rowHeaderWidth = 200) %>%
      hot_cols(colWidth = 100)
})

output$plate_config = renderRHandsontable({
    if(!is.null(input$Method_steps)) {
        index = as.numeric(input$Method_steps)
        
        config = Method$control[[index]]$plate_config
        
        rhandsontable(t(data.frame(config)), rowHeaderWidth = 200) %>%
            hot_cols(colWidth = 100)
    }
})

output$band_config = renderRHandsontable({
    if(!is.null(input$Method_steps)) {
        index = as.numeric(input$Method_steps)
        
        config = Method$control[[index]]$band_config
        print(typeof(config))
        frame = as.data.frame(matrix(unlist(config), nrow=length(unlist(config[1]))))
        rhandsontable(t(frame), rowHeaderWidth = 200) %>%
            hot_cols(colWidth = 100)
    }
})

output$Method_load_names = renderUI({
  selectizeInput("Method_load_name","Method to load",choices=dir(METHOD_DIR))
})

## feedback
output$Method_feedback = renderText({
  Method_feedback$text
})

