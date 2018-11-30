setApplicationConf  <- function(printer_head_config, plate_config, band_config, step){
    Method$control[[step]] = list(type="Sample Application",
                                  printer_head_config=printer_head_config,
                                  plate_config = plate_config,
                                  band_config = band_config)


}

toPythonTableHeadFormat  <- function(tableHeadConf) {
    keysTable = c("speed", "pulse_delay"  , "number_of_fire" , "step_range", "printer_head_resolution" )
    return (settingsTabletoPythonDict(tableHeadConf, keysTable))
}

toPythonTablePlateFormat  <- function(tablePlateConf) {
    keysPlate = c("relative_band_distance_y", "relative_band_distance_x"  , "plate_height_y" , "plate_width_x", "band_length", "gap" )
    return (settingsTabletoPythonDict(tablePlateConf, keysPlate))
}


# todo refactor
add_step  <- function(){
    step = length(Method$control) + 1
    headConf = appl_driver$get_default_printer_head_config()
    plateConf = appl_driver$get_default_plate_config()
    bandConf = appl_driver$create_band_config(5)

    bandList = bandConf$to_band_list()

    setApplicationConf(headConf, plateConf, bandList, step)

    showInfo("Please configure your sample application proccess")
}

getBandConfigFromTable <<- function(){
    bandlistTable= hot_to_r(input$band_config)
    return (bandConfSettingsTableFormatToPython(bandlistTable))

}

step_start <- function(){
    bandlistpy =  getBandConfigFromTable()
    sample_application_driver$set_band_config(bandlistpy)
    gcode = sample_application_driver$generate_gcode()
    sample_application_driver$generate_gcode_and_send()
}


observeEvent(input$sample_application_settings_update,{
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

observeEvent (input$sample_application_band_config_update,{
    band_list = getBandConfigFromTable()
    update_band_list = appl_driver$update_band_list(band_list)
    index = getSelectedStep()
    Method$control[[index]]$band_config = update_band_list
})

observeEvent (input$sample_application_band_config_save,{
    apply_table = hot_to_r(input$band_config)
    write.table(apply_table,file = file.choose(new = T))
})
