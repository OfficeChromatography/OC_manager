## server_Method.R
#-----------------------------------------------------------------------------------
# function
#-------------------------------------------------------------------------------------
##Variable
steps_choices = dir("tables/",pattern=".csv") %>% gsub(x=.,pattern=".csv",replacement="")
Method_feedback = reactiveValues(text="No feedback yet")
appl_driver = ocDriver$get_sample_application_driver()

#-----------------------------------------------------------------------------------------

showInfo  <- function(msg) {
    Method_feedback$text = msg
}

getSelectedStep  <- function(){
    return (as.numeric(input$Method_steps))
}

setApplicationConf  <- function(printer_head_config, plate_config, band_config, step){

    Method$control[[step]] = list(type="Sample Application",
                                  printer_head_config=printer_head_config,
                                  plate_config = plate_config,
                                  band_config = band_config$to_band_list())

}
# todo refactor
renderSampleApplication  <- function(){
    step = length(Method$control) + 1
    default_printer_head_config = appl_driver$get_default_printer_head_config()
    default_plate_config = appl_driver$get_default_plate_config()
    default_band_config = appl_driver$create_band_config(5)

    setApplicationConf(default_printer_head_config, default_plate_config, default_band_config, step)
    
    showInfo("Please configure your sample application proccess")

}

## methods
observeEvent(input$Method_step_add,{

    if(input$Method_step_new == "Sample Application") {
        renderSampleApplication()
    } 
    
           
})

observeEvent(input$Method_step_delete,{
    index = as.numeric(input$Method_steps)
    if(index > 0) {
        Method$control[[as.numeric(input$Method_steps)]] = NULL
    }

})

observeEvent(input$Method_steps,{
})



## start
observeEvent(input$Method_step_exec,{
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
    filePath = paste0("./method/",input$Method_save_name,".Rdata")
    print(Method$control)
    control = Method$control
    save(control,file=filePath)
    Method_feedback$text = paste0("Saved ", filePath)
})
observeEvent(input$Method_load,{
})




observeEvent(input$Method_step_update,{
    step = getSelectedStep()

    print(input$plate_config)

    plate_conf = hot_to_r(input$plate_config)
    head_conf = hot_to_r(input$printer_head_config)
    
    Method$control[[step]]$plate_config = plate_conf
    Method$control[[step]]$head_config = head_conf
        
    appl_driver$set_configs(plate_conf, head_conf)
    band_conf = appl_driver$create_band_config(5)
    setApplicationConf(head_conf, plate_conf, band_conf, step)
})
