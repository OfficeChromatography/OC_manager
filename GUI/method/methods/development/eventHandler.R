#abstract
setApplicationConf  <- function(printer_head_config, plate_config, band_config, step){
    Method$control[[step]] = list(type="Development",
                                  printer_head_config=printer_head_config,
                                  plate_config = plate_config,
                                  band_config = band_config)


}
# Application
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



#abstract
toTableHeadRFormat  <- function(pythonHeadConf){
    labels = c("Speed", "Pulse Delay", "Number of Fire", "Step Range", "Printer Head Resolution")
    units = c("mm/m", "\U00B5m", "", "mm", "mm")
    return (toRSettingsTableFormat(pythonHeadConf, labels, units))
}

#abstract
toTablePlateRFormat  <- function(pythonPlateConf) {
    pythonPlateConf$gap = NULL
    pythonPlateConf$band_length = NULL
    labels = c("Relative Band Distance [Y]", "Relative Band Distance [X]", "Plate Height [Y]", "Plate Width [X]")
    units = c("mm", "mm", "mm", "nl")
    return (toRSettingsTableFormat(pythonPlateConf, labels, units))
}
#abstract
toPythonTableHeadFormat  <- function(tableHeadConf) {
    keysTable = c("speed", "pulse_delay"  , "number_of_fire" , "step_range", "printer_head_resolution" )
    return (settingsTabletoPythonDict(tableHeadConf, keysTable))
}
#abstract
toPythonTablePlateFormat  <- function(tablePlateConf) {
    band_length_value = appl_driver$calculate_band_length()
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
    headConf = appl_driver$get_default_printer_head_config()
    plateConf = appl_driver$get_default_plate_config()
    bandConf = appl_driver$create_band_config(number_of_bands)
    bandList = bandConf$to_band_list()

    setApplicationConf(headConf, plateConf, bandList, step)

    showInfo("Please configure your sample application proccess")
}

# Application
getBandConfigFromTable <- function(){
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


    appl_driver$setup(pyPlate, pyHead)
    numberOfBands = 1
    band_conf = appl_driver$create_band_config(numberOfBands)
    bandList = band_conf$to_band_list()

    setApplicationConf(pyHead, pyPlate, bandList, step)
})

# Application
observeEvent (input$development_band_config_update,{
    band_list = getBandConfigFromTable()
    update_band_list = appl_driver$update_band_list(band_list)
    index = getSelectedStep()
    Method$control[[index]]$band_config = update_band_list
})
