methodsUI <- renderUI({
    fluidPage(
    fluidRow(
        box(title = "Settings", width = "85%", height = "45%",status = "primary",
            fluidRow(actionButton("Method_settings_update","Update settings",icon=icon("gears"), width="100%")))
    ),
    fluidRow(
    box(title = "Information", width = "85%", height = "45%",status = "primary",
        uiOutput("Method_control_infos"))
    )
    )
})


## settings
output$Method_control_settings = renderUI({
    validate(
    need(length(Method$control) > 0 ,"Add a step or load a saved method")
    )
    print ("settings")
  if(!is.null(input$Method_steps)){
    tagList(
      fluidPage(
          fluidRow(
          column(4,box(title = "Printerhead ", width = "33%", height = "45%",status = "warning",
          rHandsontableOutput("printer_head_config"))),
          column(4,box(title = "Plate Design", width = "33%", height = "45%",status = "warning",
          rHandsontableOutput("plate_config"))),
          column(4,box(title = "Update Settings", width = "33%", height = "45%",status = "warning",
          fluidRow(textInput("number_of_bands", "Number of bands", getNumberOfBands(),width="100%")),
          fluidRow(actionButton("Method_settings_update","Update settings",icon=icon("gears"), width="100%")),
          fluidRow(actionButton("Method_band_config_update","Update apply table",icon=icon("gears"), width="100%"))
          )
                   )
                  )
      )
      )
  }
})


getNumberOfBands  <- function(){
    numberOfBands = input$number_of_bands
    if (is.null ( numberOfBands )) {
        numberOfBands = 5

    }
    return (numberOfBands)
}


## information
output$Method_control_infos = renderUI({
  validate(
    need(length(Method$control) > 0 ,"Add a step or load a saved method")
  )
  if(!is.null(input$Method_steps)){
    tagList(
        column(6,box(title = "Plate Plot ", width = "33%", height = "45%",status = "warning",
        plotOutput("Method_plot",width="400px",height="400px"))),
        column(6,box(title = "Apply Table ", width = "33%", height = "45%",status = "warning",
        rHandsontableOutput("band_config")))
    )
  }
})

output$Method_plot = renderPlot({
    index = getSelectedStep()
    if (index > length(Method$control)){
        index=1
    }
    currentMethod= Method$control[[index]]
    if(!is.null(currentMethod)){
        plate_config = currentMethod$plate_config
        numberOfBands= length (currentMethod$band_config)
        createApplicationPlot(plate_config, numberOfBands)
    }
    else{
        plot(x=1,y=1,type="n",main="Update to visualize")
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
            hot_cols(colWidth = 50) %>%
	    hot_col("Label", width = 100) %>%
            hot_col("Approximate Band Start" , readOnly = TRUE) %>%
            hot_col("Approximate Band End", readOnly = TRUE) %>%
            hot_col("Volume Real", readOnly = TRUE)
    }
})
