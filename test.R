library(shiny)

ui <- shinyUI(fluidPage(
  sidebarLayout(
    sidebarPanel(
      id = "tPanel",style = "overflow-y:scroll; max-height: 600px; position:relative; ",
      uiOutput("RadioGrid2")),
    mainPanel(uiOutput("InlineChooser")) )
))

server <- shinyServer(function(input, output) {
  #Data
  RowNames = LETTERS
  ColumnNames = c("1","2","3","4","5")
  
  #Define a function that creates rows of radio buttons
  RadioRow = function(label, opts){
    choices = as.list(1:length(opts))
    names(choices) = opts
    radioButtons(paste0("Row",label),label=label,choices=choices,selected=1, inline = input$InRows)}
  
  #Define a function that creates the radio grid
  RadioGrid = function(RowNames, ColumnNames){lapply(X = RowNames, FUN = RadioRow, opts = ColumnNames)}
  
  #define a reactive object to hold the radio grid
  WidgetGrid2 = reactive({RadioGrid(RowNames, ColumnNames)})
  
  #create the output object to display the grid
  output$RadioGrid2 = renderUI({tagList(WidgetGrid2())})
  
  #create output object to select whether to do inline or not
  output$InlineChooser = renderUI(radioButtons("InRows", label = "Put in rows?", choices = list("yes" = TRUE, "no" = FALSE), selected = TRUE))
})

shinyApp(ui, server)