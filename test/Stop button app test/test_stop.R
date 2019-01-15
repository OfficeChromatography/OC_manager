library(shiny)
library(parallel)




shinyApp(
  ui = fluidPage(
    actionButton("start","Start",class="btn-primary"),
    actionButton("stop","Stop",class="btn-danger"),
    textOutput('res')
  ),
  server = function(input, output, session) {
    analyze <- function(){
      lapply(1:5, function(x) {
        Sys.sleep(1)
        x/100
      }
      )
    }
    
    rv <- reactiveValues(
      id=list(),
      msg=""
    )
    
    observeEvent(input$start, {
      if(!is.null(rv$id$pid)) return()
      rv$id <- mcparallel({ analyze() })
      rv$msg <- sprintf("%1$s started",rv$id$pid)
    })
    
    observeEvent(input$stop, {
      if(!is.null(rv$id$pid)){
        tools::pskill(rv$id$pid)
        rv$msg <- sprintf("%1$s killed",rv$id$pid)
        rv$id <- list()
      }
    })
    
    observe({
      invalidateLater(1000, session)
      if(!is.null(rv$id$pid)){
        res <- mccollect(rv$id,wait=F)
        if(is.null(res)){
          rv$msg <- sprintf("%1$s in process. Press stop to kill it",rv$id$pid)
        }else{
          rv$msg <- jsonlite::toJSON(res)
          rv$id <- list()
        }
      }
    })
    
    output$res <- renderText({
      rv$msg
    })
  }
)