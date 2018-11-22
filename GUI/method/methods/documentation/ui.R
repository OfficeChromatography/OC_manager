methodsUI_documentation <- renderUI({
    fluidPage(
    fluidRow(
        box(title = "Picture Settings", width = "85%", height = "45%",status = "primary",
           uiOutput("documentation_settings"))
    ),
    fluidRow(
    box(title = "Preview", width = "85%", height = "45%",status = "primary",
        uiOutput("documentation_preview"))
    )
    )
})


## settings
output$documentation_settings = renderUI({
    validate(
    need(length(Method$control) > 0 ,"Add a step or load a saved method")
    )
  if(!is.null(input$Method_steps)){
    tagList(
        fluidPage(
            column(10,box(title = "Pictures ", width = "33%", height = "45%",status = "warning",
                         rHandsontableOutput("pictures_config")
                         )
                   ),
            column(2,box(title = "Update Settings", width = "33%", height = "45%",status = "warning",
                         fluidRow(textInput("number_of_pictures", "Number of Pictures", getNumberOfPictures(),width="100%")),
                         fluidRow(actionButton("documentation_settings_update"," settings",icon=icon("gears"), width="100%"))
                         )
                   )
        )
        )
  }
})


getNumberOfPictures <- function(){
    numberOfPictures = input$number_of_pictures
    if (is.null ( numberOfPictures )) {
        numberOfPictures = 1

    }
    return (numberOfPictures)
}

get_Image <- function (){
    return (appl_driver$get_Preview_Path)

}


pictures_config_to_Table_Format<- function (pictures_config){
    labels = c("Picture Name", "LED-white", "LED-red", "LED-green", "LED-blue")
    fUntransposed = as.data.frame(matrix(unlist(pictures_config), nrow=length(unlist(pictures_config[1]))))
    f = t(fUntransposed)
    sortedFrame = f[, c(5, 2, 4, 3, 1)]
    colnames(sortedFrame) = labels
    rownames(sortedFrame) = c()
    return (sortedFrame)
}
    

## information
output$documentation_preview = renderUI({
  validate(
    need(length(Method$control) > 0 ,"Add a step or load a saved method")
  )
  if(!is.null(input$Method_steps)){
    tagList(
        column(8,box(title = "Image Preview", width = "33%", height = "45%",status = "warning",
        imageOutput(get_Image(), width = "400px", height = "400px"))),
        column(4,box(title = "Settings", width = "33%", height = "45%",status = "warning",
                     actionButton("documention_position",label = "Documentation Position"),
                     actionButton("take_a_picture",label = "Take a Picture", icon=icon("camera")),
                     checkboxGroupInput("documentation_select_LEDs","Select LEDs",
                              choices = appl_driver$get_LED_list(),
                              inline = T,selected = 1)
                     )
              )
        )
  }
})

 
output$Method_step_feedback = renderText({
  validate(
    need(length(Method$control) > 0 ,"add a step or load a saved method")
  )
  Method$control[[as.numeric(input$Method_steps)]]$info
})


output$pictures_config = renderRHandsontable({
    if(!is.null(input$Method_steps)) {
        index = getSelectedStep()
        pictures_list = Method$control[[index]]$pictures_config
        table = pictures_config_to_Table_Format(pictures_list)
        if (!  is.matrix(table))  {
            table = t(as.matrix(table))

        }
        rhandsontable(table, rowHeaderWidth = 160) %>%
            hot_cols(colWidth = 80) %>%
	    hot_col("Picture Name", width = 90)
    }
})
