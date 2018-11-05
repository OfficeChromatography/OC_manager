
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
                                  band_config = band_config)


}

createApplicationPlot <- function ( plate_config, numberOfBands){
    plate_width_x = as.numeric (plate_config$plate_width_x)
    plate_height_y = as.numeric (plate_config$plate_height_y)
    band_length = as.numeric (plate_config$band_length)
    relative_band_distance_x = as.numeric (plate_config$relative_band_distance_x) + 50 - plate_width_x/2
    relative_band_distance_y = as.numeric (plate_config$relative_band_distance_y) + 50 - plate_height_y/2
    gap = as.numeric (plate_config$gap)
    numberOfBands=numberOfBands

    plot(c(1,100),c(1,100),
         type="n",xaxt = 'n',
         xlim=c(0,100),ylim=c(100,0),
         xlab="",ylab="Application direction (X) ")

    axis(3)
    start=relative_band_distance_x
    mtext("Migration direction (Y)", side=3, line=3)
    for(band in seq(1,numberOfBands)){
        end=start + band_length
        segments(x0 = relative_band_distance_y,
                 y0 = start,
                 y1 = end
                 )
        start=end + gap
    }
    symbols(x=50,y=50,add = T,inches = F,rectangles = rbind(c(plate_height_y,plate_width_x)),lty=2)
}




toTableHeadRFormat  <- function(pythonHeadConf){
    labels = c("Speed", "Pulse Delay", "Number of Fire", "Step Range", "Printer Head Resolution")
    units = c("mm/m", "µm", "", "mm", "mm")
    return (toRSettingsTableFormat(pythonHeadConf, labels, units))
}

toTablePlateRFormat  <- function(pythonPlateConf) {
    labels = c("Relative Band Distance [Y]", "Relative Band Distance [X]", "Plate Height [Y]", "Plate Height [X]", "Drop Volume", "Band Length", "Gap")
    units = c("mm", "mm", "mm", "mm", "nl", "mm", "mm")
    return (toRSettingsTableFormat(pythonPlateConf, labels, units))
}

toPythonTableHeadFormat  <- function(tableHeadConf) {
    keysTable = c("speed", "pulse_delay"  , "number_of_fire" , "step_range", "printer_head_resolution" )
    return (settingsTabletoPythonDict(tableHeadConf, keysTable))
}

toPythonTablePlateFormat  <- function(tablePlateConf) {
    keysPlate = c("relative_band_distance_y", "relative_band_distance_x"  , "plate_height_y" , "plate_width_x", "drop_vol", "band_length", "gap" )
    return (settingsTabletoPythonDict(tablePlateConf, keysPlate))
}


# todo refactor
renderSampleApplication  <- function(){
    step = length(Method$control) + 1

    headConf = appl_driver$get_default_printer_head_config()
    plateConf = appl_driver$get_default_plate_config()
    bandConf = appl_driver$create_band_config(5)

    bandList = bandConf$to_band_list()

    setApplicationConf(headConf, plateConf, bandList, step)

    showInfo("Please configure your sample application proccess")
}

getBandConfigFromTable <- function(){
    bandlistTable= hot_to_r(input$band_config)
    return (bandConfSettingsTableFormatToPython(bandlistTable))

}

## methods
observeEvent(input$Method_step_add,{

    if(input$Method_step_new == "Sample Application") {
        renderSampleApplication()
    }


})

observeEvent(input$Method_step_delete,{
    index = getSelectedStep()
    if(index > 0) {
        Method$control[[as.numeric(input$Method_steps)]] = NULL
    }

})



## start
observeEvent(input$Method_step_exec,{
    bandlistpy =  getBandConfigFromTable()
    appl_driver$set_band_config(bandlistpy)
    gcode = appl_driver$generate_gcode()
    write(gcode, file="gcodeData.txt")
    appl_driver$generate_gcode_and_send()
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
        Method_feedback$text = "Method can´t load, no file selected"
    }
})




observeEvent(input$Method_settings_update,{
    step = getSelectedStep()

    plateTable = hot_to_r(input$plate_config)
    headTable = hot_to_r(input$printer_head_config)

    pyHead = toPythonTableHeadFormat(headTable)
    pyPlate = toPythonTablePlateFormat(plateTable)


    appl_driver$setup(pyPlate, pyHead)
    numberOfBands = input$number_of_bands
    band_conf = appl_driver$create_band_config(numberOfBands)
    bandList = band_conf$to_band_list()

    setApplicationConf(pyHead, pyPlate, bandList, step)
})

observeEvent (input$Method_band_config_update,{
    band_list = getBandConfigFromTable()
    update_band_list = appl_driver$update_band_list(band_list)
    index = getSelectedStep()
    Method$control[[index]]$band_config = update_band_list
})
