renderMethodsUI <- function (){
    #step = getSelectedStep ()
    type = "sample_application"
    path = "./GUI/method/methods/"
    switch (type,
            "sample_application" = {
                ## load UI
                source(paste0 (path,"sample_application/ui.R"), local=ui_methods)
                ##load event Handler
                source(paste0 (path,"sample_application/eventHandler.R"), local=eventHandler_methods)
                ##load driver
                appl_driver = ocDriver$get_sample_application_driver()
                },
            "development" = {
                ## load UI
                source(paste0 (path,"development/ui.R"), local=ui_methods)
                ##load event Handler
                source(paste0 (path,"development/eventHandler.R"), local=eventHandler_methods)
                ##load driver
                appl_driver = ocDriver$get_sample_application_driver()
                },
            "documentation" = {}
            )
}



showInfo  <- function(msg) {
    Method_feedback$text = msg
}

getSelectedStep  <- function(){
    return (as.numeric(input$Method_steps))
}



## methods
observeEvent(input$Method_step_add,{
    renderMethodsUI()
    eventHandler_methods$renderSampleApplication()

})

observeEvent(input$Method_step_delete,{
    index = getSelectedStep()
    if(index > 0) {
        Method$control[[index]] = NULL
    }
    renderMethodsUI()

})



## start
observeEvent(input$Method_step_exec,{
    bandlistpy =  eventHandler_methods$getBandConfigFromTable()
    appl_driver$set_band_config(bandlistpy)
    gcode = appl_driver$generate_gcode()
    appl_driver$generate_gcode_and_send()
})

output$Method_gcode_download <- downloadHandler(
  filename = function(x){paste0("OC_manager_",
                                Method$control[[as.numeric(input$Method_steps)]]$type,
                                "_",
                                paste0(Method$control[[as.numeric(input$Method_steps)]]$table[,2],collapse = "_"),
                                '.gcode')},
  content = function(file) {
    Method_file = paste0("./method/method_to_load/",".gcode")
    Log = Method_file
    fileConn<-file(Method_file)
    writeLines(Method$control[[as.numeric(input$Method_steps)]]$gcode, fileConn)
    close(fileConn)
    file.copy(paste0("gcode/","Method",".gcode"), file)
  }
)
## save

observeEvent(input$Method_save,{
    filePath = paste0("./method/method_to_load/",input$Method_save_name,".Rdata")

    control = Method$control
    save(control,file=filePath)
    Method_feedback$text = paste0("Saved ", filePath)
})

observeEvent(input$Method_load,{
    path = input$Method_load_name$datapath
    if (!is.null(path)){
        load(path)
        Method$control=control
        Method_feedback$text = "Method loaded"
    }
    else{
        Method_feedback$text = "Method can't load, no file selected"
    }
})


