## server_visu for OC_manager
# may be better in config.R ???
#angle = 0.25
Visu_roi = "0.27,0.2,0.6,0.6"

##
LED_pin = c("Red" = 44,"Green"=66,"Blue"=64,"254nm"=59,"dummy (bug to solve, always on)"=-1)

output$Visu_control_1 = renderUI({
  
  tagList(
    actionButton("Visu_update_dir","Update the fodler list"),
    p("Raw data are directly available in the software path"),
    hr(),
    column(6,
           uiOutput("Visu_control_dir_1"),
           uiOutput("Visu_control_pict_1"),
           uiOutput("Visu_control_img_1")
    ),
    column(6,
           uiOutput("Visu_control_dir_2"),
           uiOutput("Visu_control_pict_2"),
           uiOutput("Visu_control_img_2")
    )
  )
})
Visu_Dir = reactiveValues(dir=dir("www/pictures/"))
output$Visu_control_dir_1 = renderUI({
  selectizeInput("Visu_control_dir_1","Folder to explore",Visu_Dir$dir,selected = NULL)
})
output$Visu_control_dir_2 = renderUI({
  selectizeInput("Visu_control_dir_2","Folder to explore",Visu_Dir$dir,selected = NULL)
})
output$Visu_control_pict_1 = renderUI({
  selectizeInput("Visu_control_pict_1","Chromatogram to display",dir(paste0("www/pictures/",input$Visu_control_dir_1),full.names = T),selected = NULL,width = "400px")
})
output$Visu_control_pict_2 = renderUI({
  selectizeInput("Visu_control_pict_2","Chromatogram to display",dir(paste0("www/pictures/",input$Visu_control_dir_2),full.names = T),selected = NULL,width = "400px")
})
Visu_data_1 = reactive({
  f.read.image(input$Visu_control_pict_1,height = 1000)
})
output$Visu_control_img_1 = renderUI({
  validate(need(!is.null(input$Visu_control_dir_1),"select a folder to explore"))
  tags$img(src=gsub(pattern = "www/",replacement = "",x=input$Visu_control_pict_1),height="500px",width="500px")
})
output$Visu_control_img_2 = renderUI({
  validate(need(!is.null(input$Visu_control_dir_2),"select a folder to explore"))
  tags$img(src=gsub(pattern = "www/",replacement = "",x=input$Visu_control_pict_2),height="500px",width="500px")
})
observeEvent(input$Visu_update_dir,{
  Visu_Dir$dir = dir("www/pictures/")
})
