setApplicationConf  <- function(printer_head_config, plate_config, band_config, step){
    Method$control[[step]] = list(type="Development",
                                  printer_head_config=printer_head_config,
                                  plate_config = plate_config,
                                  band_config = band_config)


}

toPythonTableHeadFormat  <- function(tableHeadConf) {
    keysTable = c("speed", "pulse_delay"  , "number_of_fire" , "step_range", "printer_head_resolution" )
    return (settingsTabletoPythonDict(tableHeadConf, keysTable))
}
toPythonTablePlateFormat  <- function(tablePlateConf) {
    band_length_value = development_driver$calculate_band_length()
    append_dataFrame = data.frame(row.names=c("Band Length","Gap"),
                                  "values"= c(band_length_value,0), "units" = c("mm","mm"))
    tablePlateConf_appended = rbind(tablePlateConf,append_dataFrame)
    keysPlate = c("relative_band_distance_y", "relative_band_distance_x"  , "plate_height_y" , "plate_width_x", "band_length","gap")
    return (settingsTabletoPythonDict(tablePlateConf_appended, keysPlate))
}

getBandConfigFromTable <- function(){
    bandlistTable= hot_to_r(input$band_config)
    return (bandConfSettingsTableFormatToPython(bandlistTable))

}

getPlateConfigFromTable <- function (){
    plateTable = hot_to_r(input$plate_config)
    return (toPythonTablePlateFormat(plateTable)) 
}

getHeadConfigFromTable <- function (){
    headTable = hot_to_r(input$printer_head_config)
    return (toPythonTableHeadFormat(headTable)) 
}


step_add  <- function(){
    step = length(Method$control) + 1
    headConf = development_driver$get_default_printer_head_config()
    plateConf = development_driver$get_default_plate_config()
    bandConf = development_driver$update_settings(plateConf, headConf)

    setApplicationConf(headConf, plateConf, bandConf, step)

    showInfo("Please configure your sample application proccess")
}

step_save <- function(){
    pyPlate = getPlateConfigFromTable()
    pyHead = getHeadConfigFromTable()
    band_list = getBandConfigFromTable()
    step = getSelectedStep()
    setApplicationConf(pyHead, pyPlate, bandList, step)
}

step_start <- function(){
    bandlistpy =  getBandConfigFromTable()
    development_driver$start_application(bandlistpy)
}

observeEvent(input$development_settings_update,{
    step = getSelectedStep()
    pyPlate = getPlateConfigFromTable()
    pyHead = getHeadConfigFromTable()
    bandList = development_driver$update_settings(pyPlate, pyHead)

    setApplicationConf(pyHead, pyPlate, bandList, step)
})


observeEvent (input$development_band_config_save,{
    apply_table = hot_to_r(input$band_config)
    write.table(apply_table,file = file.choose(new = T))
})

