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
    units = c("mm/m", "\U00B5m", "", "mm", "mm")
    return (toRSettingsTableFormat(pythonHeadConf, labels, units))
}

toTablePlateRFormat  <- function(pythonPlateConf) {
    labels = c("Relative Band Distance [Y]", "Relative Band Distance [X]", "Plate Height [Y]", "Plate Width [X]", "Band Length", "Gap")
    units = c("mm", "mm", "mm", "nl", "mm", "mm")
    return (toRSettingsTableFormat(pythonPlateConf, labels, units))
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
