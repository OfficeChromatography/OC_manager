methodsUI_documentation <- renderUI({
    fluidPage(
    fluidRow(
        box(title = "Settings", width = "85%", height = "45%",status = "primary",
           uiOutput("docmentation_control_settings"))
    ),
    fluidRow(
    box(title = "Information", width = "85%", height = "45%",status = "primary",
        uiOutput("documentation_control_infos"))
    )
    )
})


## settings
output$documentation_control_settings = renderUI({
    validate(
    need(length(Method$control) > 0 ,"Add a step or load a saved method")
    )
  if(!is.null(input$Method_steps)){
    tagList(
      fluidPage(
          fluidRow(
          column(5,box(title = "Pictures ", width = "33%", height = "45%",status = "warning",
          rHandsontableOutput("pictures_config"))),
          column(2,box(title = "Update Settings", width = "33%", height = "45%",status = "warning",
          fluidRow(textInput("number_of_pictures", "Number of Pictures", getNumberOfPictures(),width="100%")),
          fluidRow(actionButton("documentation_settings_update"," settings",icon=icon("gears"), width="100%"))
                   )
          )
                   )
                  )
      )
      )
  }
})


getNumberOfPictures <- function(){
    numberOfBands = input$number_of_bands
    if (is.null ( numberOfBands )) {
        numberOfBands = 5

    }
    return (numberOfBands)
}


## information
output$documentation_control_infos = renderUI({
  validate(
    need(length(Method$control) > 0 ,"Add a step or load a saved method")
  )
  if(!is.null(input$Method_steps)){
    tagList(
        column(8,box(title = "Documentation Stream ", width = "33%", height = "45%",status = "warning",
        plotOutput("documentation_stream",width="400px",height="400px"))),
        column(4,box(title = "LEDs", width = "33%", height = "45%",status = "warning",
        actionButton("documention_position",label = "Documentation Position"),
        checkboxGroupInput("documentation_select_LEDs","Select LEDs",
                              choices = seq(DocumentationDriver$getLEDs()),
                              inline = T,selected = 1)
    )
  }
})

output$documentation_plot = renderPlot({
    index = getSelectedStep()
    if (index > length(Method$control)){
        index=1
    }
    currentMethod= Method$control[[index]]
    if(!is.null(currentMethod)){
        plate_config = currentMethod$plate_config
        numberOFPictures= length (currentMethod$band_config)
        createApplicationPlot(plate_config, numberOFPictures)
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
            hot_cols(colWidth = 80) %>%
	    hot_col("Label", width = 90) %>%
	    hot_col("Nozzle Id", width = 50) %>%
            hot_col("approx. Band Start [mm]" , readOnly = TRUE) %>%
            hot_col("approx. Band End [mm]", readOnly = TRUE) %>%
            hot_col("Volume Real [µl]", readOnly = TRUE)
    }
})
