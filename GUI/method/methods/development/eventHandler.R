#abstract
setApplicationConf  <- function(printer_head_config, plate_config, band_config, step){
    Method$control[[step]] = list(type="Development",
                                  printer_head_config=printer_head_config,
                                  plate_config = plate_config,
                                  band_config = band_config)


}

#abstract
toPythonTableHeadFormat  <- function(tableHeadConf) {
    keysTable = c("speed", "pulse_delay"  , "number_of_fire" , "step_range", "printer_head_resolution" )
    return (settingsTabletoPythonDict(tableHeadConf, keysTable))
}
#abstract
toPythonTablePlateFormat  <- function(tablePlateConf) {
    band_length_value = development_driver$calculate_band_length()
    append_dataFrame = data.frame(row.names=c("Band Length","Gap"),
                                  "values"= c(band_length_value,0), "units" = c("mm","mm"))
    tablePlateConf_appended = rbind(tablePlateConf,append_dataFrame)
    keysPlate = c("relative_band_distance_y", "relative_band_distance_x"  , "plate_height_y" , "plate_width_x", "band_length","gap")
    return (settingsTabletoPythonDict(tablePlateConf_appended, keysPlate))
}



# abstract
add_step  <- function(){
    step = length(Method$control) + 1
    number_of_bands = 1
    headConf = development_driver$get_default_printer_head_config()
    plateConf = development_driver$get_default_plate_config()
    bandConf = development_driver$create_band_config(number_of_bands)
    bandList = bandConf$to_band_list()

    setApplicationConf(headConf, plateConf, bandList, step)

    showInfo("Please configure your sample application proccess")
}

step_start <- function(){
    bandlistpy =  getBandConfigFromTable()
    development_driver$set_band_config(bandlistpy)
    gcode = development_driver$generate_gcode()
    development_driver$generate_gcode_and_send()
}

# Application
getBandConfigFromTable <<- function(){
    bandlistTable= hot_to_r(input$band_config)
    return (bandConfSettingsTableFormatToPython(bandlistTable))

}

#abstract
observeEvent(input$development_settings_update,{
    step = getSelectedStep()

    plateTable = hot_to_r(input$plate_config)
    headTable = hot_to_r(input$printer_head_config)

    pyHead = toPythonTableHeadFormat(headTable)
    pyPlate = toPythonTablePlateFormat(plateTable)


    development_driver$setup(pyPlate, pyHead)
    numberOfBands = 1
    band_conf = development_driver$create_band_config(numberOfBands)
    bandList = band_conf$to_band_list()

    setApplicationConf(pyHead, pyPlate, bandList, step)
})

# Application
observeEvent (input$development_band_config_update,{
    band_list = getBandConfigFromTable()
    update_band_list = development_driver$update_band_list(band_list)
    index = getSelectedStep()
    Method$control[[index]]$band_config = update_band_list
})

observeEvent (input$development_band_config_save,{
    apply_table = hot_to_r(input$band_config)
    write.table(apply_table,file = file.choose(new = T))
})

