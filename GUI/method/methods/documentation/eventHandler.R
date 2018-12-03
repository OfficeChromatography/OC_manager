#abstract
setDocumentationConf  <- function(pictures_config, preview_config, step){
    Method$control[[step]] = list(type="Documentation",
                                  pictures_config = pictures_config,
                                  preview_config = preview_config)

}


# abstract
add_step  <- function(){
    step = length(Method$control) + 1
    pictures_config = documentation_driver$get_picture_list()
    preview_config = documentation_driver$get_preview_list()
    setDocumentationConf(pictures_config, preview_config, step)
                         
    showInfo("Please configure your documentation proccess")
}


step_start <- function(){

}



# Application
getBandConfigFromTable <<- function(){
    bandlistTable= hot_to_r(input$band_config)
    return (bandConfSettingsTableFormatToPython(bandlistTable))

}

#abstract
observeEvent(input$documentation_settings_update,{
    print ("Settings")
})


observeEvent(input$take_a_picture,{
    documentation_driver$preview()
    creat_random_image_hash()
    
})


