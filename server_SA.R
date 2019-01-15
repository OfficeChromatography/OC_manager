## server_SA.R


output$SA_control_1 = renderUI({
  validate(
    need(connect$board,"Please connect the board")
  )
  tagList(
    # checkboxInput("SA_hold_gcode","SA_hold_gcode",T),
    textInput("SA_file_name","file name","SA_file_name"),
    actionButton("SA_action","Launch Gcode"),
    uiOutput("SA_infoGcode")
  )
})
output$SA_options = renderTable({
  data = read.table("tables/SA_table.csv",header=T,sep=";")
  data$Value <- paste0("<input id='SA_",data$Value,"' class='shiny-bound-input' type='number'  value='",data$Default,"'>")
  data[,c(1,2)]
}, sanitize.text.function = function(x) x)
SA_nbr_band = reactive({
  input$SA_nbr_band
})
output$SA_appli = renderTable({
  data = data.frame(Band = seq(SA_nbr_band()),Value = paste0("volume_band_",seq(SA_nbr_band())),Default = seq(SA_nbr_band()))
  data$Value <- paste0("<input id='SA_",data$Value,"' class='shiny-bound-input' type='number'  value='",data$Default,"'>")
  data[,c(1,2)]
}, sanitize.text.function = function(x) x)
SA_volumes = reactive({
  truc = c()
  for(i in seq(SA_nbr_band())){
    truc = c(truc,input[[paste0("SA_volume_band_",i)]])
  }
  truc
})
SA_bitmap_a = reactive({ ## no bitmap anymore
  if(F){#input$SA_hold_gcode
    a = NULL
  }else{
    ## empty array
    inche = 25.4 # mm/inche
    dpi = 96
    reso = inche/dpi
    nozzle_Y = 12
    plate_Y=100
    path = max(SA_volumes())
    Y=floor(plate_Y/reso/nozzle_Y)*nozzle_Y
    a = array(0,dim = c(Y,path))
    ## fill the array
    dist_bottom = ceiling(input$SA_dist_bottom/reso)
    dist_gauche = ceiling(input$SA_dist_gauche/reso)
    band_length = ceiling(input$SA_band_length/reso)
    gap = ceiling(input$SA_gap/reso)
    dist_gauche_saved = dist_gauche
    for(i in seq(input$SA_nbr_band)){
      a[dist_gauche:(dist_gauche+band_length),1:SA_volumes()[i]] = 1
      dist_gauche = dist_gauche+band_length+gap
    }
    a
  }
})
SA_bitmap_b = reactive({ ## no bitmap anymore
  a = SA_bitmap_a()
  ## empty array
  inche = 25.4 # mm/inche
  dpi = 96
  reso = inche/dpi
  nozzle_Y = 12
  plate_Y=100
  Y=floor(plate_Y/reso/nozzle_Y)*nozzle_Y
  path=dim(a)[2]
  ## redim array
  b = array(0,dim=c(Y/nozzle_Y,dim(a)[2]))
  
  BinToDec <- function(x) {sum(2^(which(x == 1)-1))}
  
  DecToBin <- function(x){  rev(as.numeric(sapply(strsplit(paste(rev(intToBits(x))),""),`[[`,2)))[1:4]}
  
  for(i in seq(path)){
    for(j in seq(Y/nozzle_Y)){
      b[j,i] = BinToDec(a[((j-1)*nozzle_Y+1):(j*nozzle_Y),i])
    }
  }
  b
})
SA_gcode <- reactive({
  if(pulse_delay_secu){
    validate(
      need(input$SA_L<20,"pulse delay to big, must be inforior to 20, disable secu in config.R file")
    )
  }
  start_gcode = c("G28 X0; home X axis",
                  "G28 Y0; home Y axis",
                  "G21 ; set units to millimeters",
                  "G90 ; use absolute coordinates",
                  paste0("G1 F",60*input$SA_speed," ; set speed in mm per min for the movement"),
                  paste0("G1 X",input$SA_dist_bottom," ; go in X position")
  )
  end_gcode = c("G28 X0; home X axis",
                "G28 Y0; home Y axis",
                "M84     ; disable motors")
  
  a_to_gcode_X_fix(SA_bitmap_a(),start_gcode,end_gcode,I=input$SA_I,L=input$SA_L,W=input$SA_wait,nozzle = input$SA_nozzle)
})
output$SA_plot <- renderPlot({
  plot(c(1,100),c(1,dim(SA_bitmap_a())[1]),type="n",xlim=c(100,0),xlab="X",ylab="Y",main="Origin in upper right corner",sub="the origin is not the same as usual, I must fix it")
  rasterImage(1-apply(SA_bitmap_a(),c(1),mean),xleft = input$SA_dist_bottom,xright=input$SA_dist_bottom+0.5,ybottom = 1,ytop=dim(SA_bitmap_a())[1])
})
observeEvent(input$SA_action,{
  # create the gcode
  SA_file = paste0("gcode/",format(Sys.time(),"%Y%m%d_%H:%M:%S"),input$SA_file_name,".gcode")
  Log = SA_file
  fileConn<-file(SA_file)
  writeLines(SA_gcode(), fileConn)
  close(fileConn)
  # put it in the log
  write(paste0(format(Sys.time(),"%Y%m%d_%H:%M:%S"),";","Sample_application;",SA_file,";",Log,";",connect$Visa,";",input$Plate),file="log/log.txt",append = T)
  # send the gcode
  python.call("send_gcode",SA_file)
})
output$SA_infoGcode = renderUI({
  tagList(
    h6(paste0(SA_nbr_band()," bands")), ## need number of nozzle fired and position fired
    h6(paste0(paste0("Number of nozzles fired: ",sum(SA_bitmap_a())*input$SA_I))),
    h6(paste0("Number of positions fired: ",sum(as.logical(SA_bitmap_b()))))
  )
  
})

output$SA_gcode <- renderDataTable({
  data.frame(gcode = SA_gcode())
},options = list(pageLength = 10))