#abstract
setDocumentationConf  <- function(pictures_config, step){
    Method$control[[step]] = list(type="Documentation",
                                  pictures_config )

}


# abstract
add_step  <- function(){
    step = length(Method$control) + 1
    pictures_config = appl_driver$get_picture_list()
    setDocumentationConf(pictures_config, step)
                         
    showInfo("Please configure your documentation proccess")
}

# Application
getBandConfigFromTable <<- function(){
    bandlistTable= hot_to_r(input$band_config)
    return (bandConfSettingsTableFormatToPython(bandlistTable))

}

#abstract
observeEvent(input$documentation_settings_update,{
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
observeEvent (input$documentation_band_config_update,{
    band_list = getBandConfigFromTable()
    update_band_list = appl_driver$update_band_list(band_list)
    index = getSelectedStep()
    Method$control[[index]]$band_config = update_band_list
})


