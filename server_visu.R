## server_visu for OC_manager
# may be better in config.R ???
#angle = 0.25
Visu_roi = "0.27,0.2,0.6,0.6"

##
LED_pin = c("Red" = 44,"Green"=66,"Blue"=64,"254nm"=59,"dummy (bug to solve, always on)"=-1)

output$Visu_control_1 = renderUI({
  
  tabsetPanel(
    tabPanel("Capture",
             column(3,
                    textInput("Visu_name","Name of the folder","sandbox"),
                    uiOutput("Visu_control_action"),
                    checkboxGroupInput("Visu_RGB_254_LED","LED to turn on",choices = LED_pin,selected=LED_pin[5]),
                    checkboxInput("Visu_awb_off","Turn off automatic white balance",FALSE),
                    verbatimTextOutput("Visu_feedback"),
                    column(6,
                           checkboxGroupInput("Visu_exp","Exposure choice",c("auto",50,100,200,400,800),selected = 100)
                           ),
                    column(6,
                           checkboxGroupInput("Visu_ISO","ISO choice",c("auto",100,200,400,800),selected = c(100))
                           ),
                    textInput("Visu_roi","ROI to input in raspistill",Visu_roi),
                    actionButton("Visu_christmas","Christmas")
             ),
             column(9,
                    # verbatimTextOutput("Visu_dir"),
                    column(6,
                           uiOutput("Visu_control_dir_1"),
                           uiOutput("Visu_control_pict_1"),
                           uiOutput("Visu_control_img_1")
                           # plotOutput("Visu_control_img_1",click = "click_Visu_control_img_1",height="400px",width="400px"),
                           # plotOutput("Visu_control_chrom_1",height="400px",width="400px")
                    ),
                    column(6,
                           uiOutput("Visu_control_dir_2"),
                           uiOutput("Visu_control_pict_2"),
                           uiOutput("Visu_control_img_2")
                           # plotOutput("Visu_control_img_2",click = "click_Visu_control_img_2",height="400px",width="400px"),
                           # plotOutput("Visu_control_chrom_2",height="400px",width="400px")
                    )
                    
             )
    )
  )
})
Visu_feedback = reactiveValues(text="No feedback yet")
Visu_Dir = reactiveValues(dir=dir("www/pictures/"))
output$Visu_feedback = renderPrint({
  Visu_feedback$text
})
output$Visu_dir = renderPrint({
  Visu_Dir$dir
})
output$Visu_control_dir_1 = renderUI({
  selectizeInput("Visu_control_dir_1","Folder to explore",Visu_Dir$dir,selected = NULL)
})
output$Visu_control_dir_2 = renderUI({
  selectizeInput("Visu_control_dir_2","Folder to explore",Visu_Dir$dir,selected = NULL)
})
output$Visu_control_pict_1 = renderUI({
  selectizeInput("Visu_control_pict_1","Picture to explore",dir(paste0("www/pictures/",input$Visu_control_dir_1),full.names = T),selected = NULL,width = "400px")
})
output$Visu_control_pict_2 = renderUI({
  selectizeInput("Visu_control_pict_2","Picture to explore",dir(paste0("www/pictures/",input$Visu_control_dir_2),full.names = T),selected = NULL,width = "400px")
})
Visu_data_1 = reactive({
  f.read.image(input$Visu_control_pict_1,height = 1000)
})
output$Visu_control_img_1 = renderUI({
  validate(need(!is.null(input$Visu_control_dir_1),"select a folder to explore"))
  # par(mar=c(0,0,0,0))
  # raster(Visu_data_1())
  tags$img(src=gsub(pattern = "www/",replacement = "",x=input$Visu_control_pict_1),height="300px",width="300px")
})
output$Visu_control_chrom_1 = renderPlot({
  chrom.pict(Visu_data_1(),x=input$click_Visu_control_img_1$x,edge=10)
})
Visu_data_2 = reactive({
  f.read.image(input$Visu_control_pict_2,height = 1000)
})
output$Visu_control_img_2 = renderUI({
  validate(need(!is.null(input$Visu_control_dir_2),"select a folder to explore"))
  # par(mar=c(0,0,0,0))
  # raster(Visu_data_2())
  tags$img(src=gsub(pattern = "www/",replacement = "",x=input$Visu_control_pict_2),height="300px",width="300px")
})
output$Visu_control_chrom_2 = renderPlot({
  chrom.pict(Visu_data_2(),x=input$click_Visu_control_img_2$x,edge=10)
})

output$Visu_control_action = renderUI({
  validate(
    need(connect$login,"Please login")
  )
  tagList(
    actionButton("Visu_action","take picture"),
    # actionButton("Visu_delete_repo","Delete directory"),
    actionButton("Visu_position","Go in position (X130 Y20), home first")
  )
})

observeEvent(input$Visu_action,{
  # if(input$Visu_name %in% dir("www/pictures/")){
  #   Visu_feedback$text = "Change the name, directory already exist"
  # }else{
    withProgress(message = "Processing", value=0,min=0,max=length(input$Visu_ISO)*length(input$Visu_exp)+1, {
      dir.create(paste0("www/pictures/",input$Visu_name))
      incProgress(1,message="Directory created")
      for(ISO in input$Visu_ISO){
        for(exp in input$Visu_exp){
          Visu_file = paste0("www/pictures/",input$Visu_name,"/",exp,"ms_iso_",ISO,".jpg")
          command = paste0("raspistill "," -n "," -roi ",input$Visu_roi," -w 2000 -h 2000")
          if(ISO != "auto"){
            command = paste0(command,"  -ISO ",ISO)
          }
          if(exp != "auto"){
            command = paste0(command," -ss ",exp,"000")
          }
          if(input$Visu_awb_off){
            Visu_file = paste0("www/pictures/",input$Visu_name,"/",exp,"ms_iso_",ISO,"_awb_off.jpg")
            command = paste0(command," -awb off")
          }
          command = paste0(command," -o ",Visu_file)
          system(command)
          #print(command)
          incProgress(1,message=command)
        }
      }
    })
    Visu_feedback$text = "Everything looks good, pictures created"
    Visu_Dir$dir = dir("www/pictures/")
    updateSelectizeInput(session,inputId = "Visu_control_dir_1",selected = input$Visu_name)
  # }
})
observeEvent(input$Visu_position,{
  if(connect$board){
    python.call("send_cmd","G1 X130 Y20")
  }
})
observeEvent(input$Visu_RGB_254_LED,{
  if(connect$board){
    for(i in LED_pin[1:3]){
      if(i %in% input$Visu_RGB_254_LED){
        python.call("send_cmd",paste0("M42 P",i," S255"))
      }else{
        python.call("send_cmd",paste0("M42 P",i," S0"))
      }
    }
    if(LED_pin[4] %in% input$Visu_RGB_254_LED){
      python.call("send_cmd",paste0("M42 P",LED_pin[4]," S0"))
    }else{
      python.call("send_cmd",paste0("M42 P",LED_pin[4]," S255"))
    }
  }
})

observeEvent(input$Visu_christmas,{
  if(connect$board){
    for(i in sample(1:6,50,T)){
      if(i %in% seq(3)){
        python.call("send_cmd",paste0("M42 P",LED_pin[i]," S255"))
        Sys.sleep(0.5)
        python.call("send_cmd",paste0("M42 P",LED_pin[i]," S0"))
      }else if(i == 7){
        for(j in LED_pin[1:3]){
          python.call("send_cmd",paste0("M42 P",j," S255"))
        }
        Sys.sleep(0.5)
        for(j in LED_pin[1:3]){
          python.call("send_cmd",paste0("M42 P",j," S0"))
        }
      }else if(i == 4){
        for(j in LED_pin[1:2]){
          python.call("send_cmd",paste0("M42 P",j," S255"))
        }
        Sys.sleep(0.5)
        for(j in LED_pin[1:2]){
          python.call("send_cmd",paste0("M42 P",j," S0"))
        }
      }else if(i == 5){
        for(j in LED_pin[3:2]){
          python.call("send_cmd",paste0("M42 P",j," S255"))
        }
        Sys.sleep(0.5)
        for(j in LED_pin[3:2]){
          python.call("send_cmd",paste0("M42 P",j," S0"))
        }
      }else if(i == 6){
        for(j in LED_pin[c(1,3)]){
          python.call("send_cmd",paste0("M42 P",j," S255"))
        }
        Sys.sleep(0.5)
        for(j in LED_pin[c(1,3)]){
          python.call("send_cmd",paste0("M42 P",j," S0"))
        }
      }
    }
  }
  
})