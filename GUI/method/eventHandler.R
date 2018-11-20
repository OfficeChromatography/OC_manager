renderMethodsUI <- function (type){
    path = "./GUI/method/methods/"
    renderMethods = ""
    switch (type,
            "Sample Application" = {
                ## load UI
                source(paste0 (path,"sample_application/ui.R"), local=T)
                ##load event Handler
                source(paste0 (path,"sample_application/eventHandler.R"), local=T)
                output$methodUI  <- methodsUI_sample_application
                ##load driver
                appl_driver <<- ocDriver$get_sample_application_driver()
                },
            "Development" = {
                ## load UI
                source(paste0 (path,"development/ui.R"), local=T)
                output$methodUI <- methodsUI_development
                ##load event Handler
                source(paste0 (path,"development/eventHandler.R"), local=T)
                ##load driver
                appl_driver <<- ocDriver$get_development_driver()
                },
            "Documentation" = {
                ## load UI
                source(paste0 (path,"documentation/ui.R"), local=T)
                output$methodUI <- methodsUI_documentation
                ##load event Handler
                source(paste0 (path,"documentation/eventHandler.R"), local=T)
                ##load driver
                appl_driver <<- ocDriver$get_documentation_driver()
                }
            )
    step_add_Methods <<- add_step

}



showInfo  <<- function(msg) {
    Method_feedback$text = msg
}

getSelectedStep  <<- function(){
    return (as.numeric(input$Method_steps))
}

get_Method_type <<- function () {
    index = getSelectedStep()
    return (Method$control[[index]]$type)
}



## methods
observeEvent(input$Method_step_add,{
g    type = input$Method_step_new
    renderMethodsUI(type)
    step_add_Methods()
    Method$selected = length(Method$control)
})

observeEvent(input$Method_step_delete,{
    index = getSelectedStep()
    if(index > 0) {
        Method$control[[index]] = NULL
    }
    Method$selected = length (Method$control)

})



## start
observeEvent(input$Method_step_exec,{
    bandlistpy =  getBandConfigFromTable()
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
    Method$selected = 1
})


observeEvent(input$Method_steps,{
    type = get_Method_type()
    renderMethodsUI(type)
    Method$selected = getSelectedStep()
 })
