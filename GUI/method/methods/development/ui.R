

methodsUI_development = renderUI ({
    fluidPage(
    fluidRow(
    box(title = "Settings", width = "85%", height = "45%",status = "primary",
        uiOutput("development_control_settings"))
    ),
    fluidRow(
    box(title = "Information", width = "85%", height = "45%",status = "primary",
        uiOutput("development_control_infos"))
    )
    )
})


## settings
output$development_control_settings = renderUI({
    validate(
    need(length(Method$control) > 0 ,"Add a step or load a saved method")
    )

  if(!is.null(input$Method_steps)){
    tagList(
      fluidPage(
          fluidRow(
          column(5,box(title = "Printerhead ", width = "33%", height = "45%",status = "warning",
          rHandsontableOutput("printer_head_config"))),
          column(5,box(title = "Plate Design", width = "33%", height = "45%",status = "warning",
          rHandsontableOutput("plate_config"))),
          column(2,box(title = "Update Settings", width = "33%", height = "45%",status = "warning",
          fluidRow(actionButton("development_settings_update"," settings",icon=icon("gears"), width="100%")),
          fluidRow(actionButton("development_band_config_save"," apply table",icon=icon("save"), width="100%")
                   )
          )
                   )
                  )
      )
      )
  }
})

## information
output$development_control_infos = renderUI({
  validate(
    need(length(Method$control) > 0 ,"Add a step or load a saved method")
  )
  if(!is.null(input$Method_steps)){
    tagList(
        column(6,box(title = "Plate Plot ", width = "33%", height = "45%",status = "warning",
        plotOutput("development_plot",width="400px",height="400px"))),
        column(6,box(title = "Apply Table ", width = "33%", height = "45%",status = "warning",
        rHandsontableOutput("band_config")))
    )
  }
})

# Application
createApplicationPlot <- function ( plate_config){
    plate_width_x = as.numeric (plate_config$plate_width_x)
    plate_height_y = as.numeric (plate_config$plate_height_y)
    band_length = as.numeric (plate_config$band_length)
    relative_band_distance_x = as.numeric (plate_config$relative_band_distance_x) + 50 - plate_width_x/2
    relative_band_distance_y = as.numeric (plate_config$relative_band_distance_y) + 50 - plate_height_y/2
    
    plot(c(1,100),c(1,100),
         type="n",xaxt = 'n',
         xlim=c(0,100),ylim=c(100,0),
         xlab="",ylab="Application direction (X) ")

    axis(3)
    start=relative_band_distance_x
    mtext("Migration direction (Y)", side=3, line=3)
    end=start + band_length
    segments(x0 = relative_band_distance_y,
             y0 = start,
             y1 = end
             )
    symbols(x=50,y=50,add = T,inches = F,rectangles = rbind(c(plate_height_y,plate_width_x)),lty=2)
}



#abstract
toTableHeadRFormat  <- function(pythonHeadConf){
    labels = c("Speed", "Pulse Delay", "Number of Fire", "Step Range", "Printer Head Resolution")
    units = c("mm/m", "\U00B5m", "", "mm", "mm")
    return (toRSettingsTableFormat(pythonHeadConf, labels, units))
}

#abstract
toTablePlateRFormat  <- function(pythonPlateConf) {
    pythonPlateConf$gap = NULL
    pythonPlateConf$band_length = NULL
    labels = c("Relative Band Distance [Y]", "Relative Band Distance [X]", "Plate Height [Y]", "Plate Width [X]")
    units = c("mm", "mm", "mm", "mm")
    return (toRSettingsTableFormat(pythonPlateConf, labels, units))
}


output$development_plot = renderPlot({
    index = getSelectedStep()
    if (index > length(Method$control)){
        index=1
    }
    currentMethod= Method$control[[index]]
    if(!is.null(currentMethod)){
        plate_config = currentMethod$plate_config
        numberOfBands= length (currentMethod$band_config)
        createApplicationPlot(plate_config)
    }
    else{
!        plot(x=1,y=1,type="n",main="Update to visualize")
    }
})
output$Method_step_feedback = renderText({
  validate(
    need(length(Method$control) > 0 ,"add a step or load a saved method")
  )
  Method$control[[as.numeric(input$Method_steps)]]$info
})

output$printer_head_config = renderRHandsontable({  validate(
    need(length(Method$control) > 0 ,"Please add a new step (for example: Sample Application)")
  )
  index = getSelectedStep()
  config = Method$control[[index]]$printer_head_config
  table = toTableHeadRFormat(config)

  rhandsontable(table, rowHeaderWidth = 160) %>%
      hot_cols(colWidth = 50)  %>%
            hot_col("units", readOnly = TRUE)
})

output$plate_config = renderRHandsontable({
    if(!is.null(input$Method_steps)) {
        index = getSelectedStep()
        config = Method$control[[index]]$plate_config
        table = toTablePlateRFormat(config)
        rhandsontable(table, rowHeaderWidth = 160) %>%
            hot_cols(colWidth = 50) %>%
            hot_col("units", readOnly = TRUE)

    }
})

output$band_config = renderRHandsontable({
    if(!is.null(input$Method_steps)) {
        index = getSelectedStep()
        bandlist = Method$control[[index]]$band_config
        table = bandConfToRSettingsTableFormat( bandlist)
        if (!  is.matrix(table))  {
            table = t(as.matrix(table))

        }
        rhandsontable(table, rowHeaderWidth = 160) %>%
            hot_cols(colWidth = 80) %>%
	    hot_col("Label", width = 90) %>%
	    hot_col("Nozzle Id", width = 50) %>%
            hot_col("approx. Band Start [mm]" , readOnly = TRUE) %>%
            hot_col("approx. Band End [mm]", readOnly = TRUE) %>%
            hot_col("Volume Real [µl]", readOnly = TRUE)
    }
})
