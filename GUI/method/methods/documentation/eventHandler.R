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
    pictures_list = getPicturesConfigFromTable()
    withProgress(message = 'Making pictures please wait', value = 0, {
        documentation_driver$make_pictures_for_documentation(pictures_list)
       })
}


step_save<-function(){
   pictures_list = getPicturesConfigFromTable()
   step = getSelectedStep()
   Method$control[[step]]$pictures_config = pictures_list
}

getPicturesConfigFromTable  <- function(){
    settingsFormat = hot_to_r(input$pictures_config)
    keys = c("label", "white","red","green","blue")
    pictureslist = c()
    for (row in 1:nrow(settingsFormat)){
        rowValues = settingsFormat[row,]
        pictures = py_to_r(py_dict(keys, rowValues))
        pictureslist[[row]] = pictures
    }
    return (pictureslist)
}

getPreviewConfigFromTable <- function (){
    Values = hot_to_r(input$preview_config)
    Values = c(Values,"Preview")
    keys = c("white","red","green","blue","label")
    pictureslist = py_to_r(py_dict(keys, Values))
    return (pictureslist)
}

observeEvent(input$documentation_pictures_update,{
    number_of_pictures = getNumberOfPictures()
    pictures_list = documentation_driver$update_number_of_pictures(number_of_pictures)
    step = getSelectedStep()
    Method$control[[step]]$pictures_config = pictures_list    
})


observeEvent(input$take_a_picture,{
    preview_list = getPreviewConfigFromTable()
    documentation_driver$update_preview(preview_list)
    documentation_driver$make_preview()
    creat_random_image_hash()
    
})


