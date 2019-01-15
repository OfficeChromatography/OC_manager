## server_Dev.R


output$Dev_control_1 = renderUI({
  validate(
    need(connect$board,"Please connect the board")
  )
  tagList(
    # checkboxInput("Dev_hold_gcode","Dev_hold_gcode",T),
    textInput("Dev_file_name","file name","Dev_file_name"),
    actionButton("Dev_action_stop","Stop Gcode"),
    actionButton("Dev_action","Launch Gcode"),
    textOutput('res'),
    uiOutput("Dev_infoGcode")
  )
})
output$Dev_options = renderTable({
  data = read.table("tables/Dev_table.csv",header=T,sep=";")
  data$Value <- paste0("<input id='Dev_",data$Value,"' class='shiny-bound-input' type='number'  value='",data$Default,"'>")
  data[,c(1,2)]
}, sanitize.text.function = function(x) x)
Dev_nbr_band = reactive({
  input$Dev_nbr_band
})
Dev_bitmap_a = reactive({ ## no bitmap anymore
  if(F){#input$Dev_hold_gcode
    a = NULL
  }else{
    ## empty array
    inche = 25.4 # mm/inche
    dpi = 96
    reso = inche/dpi
    nozzle_Y = 12
    plate_Y=100
    path = input$Dev_path
    Y=floor(plate_Y/reso/nozzle_Y)*nozzle_Y
    a = array(0,dim = c(Y,path))
    ## fill the array
    dist_bottom = ceiling(input$Dev_dist_bottom/reso)
    dist_gauche = ceiling(input$Dev_dist_gauche/reso)
    band_length = ceiling(input$Dev_band_length/reso)
    gap = ceiling(input$Dev_gap/reso)
    dist_gauche_saved = dist_gauche
    for(i in seq(input$Dev_nbr_band)){
      a[dist_gauche:(dist_gauche+band_length),] = 1
      dist_gauche = dist_gauche+band_length+gap
    }
    a
  }
})
Dev_bitmap_b = reactive({ ## no bitmap anymore
  a = Dev_bitmap_a()
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
# initial.Dev_action <- 0

observeEvent(input$Dev_action,{
  # create the gcode
  Dev_file = paste0("gcode/",format(Sys.time(),"%Y%m%d_%H:%M:%S"),input$Dev_file_name,".gcode")
  Log = Dev_file
  
  # put it in the log
  write(paste0(format(Sys.time(),"%Y%m%d_%H:%M:%S"),";","Sample_application;",Dev_file,";",Log,";",connect$Visa,";",input$Plate),file="log/log.txt",append = T)
  
  ## start gcode
  fileConn<-file(Dev_file)
  writeLines(Dev_gcode()[[1]], fileConn)
  close(fileConn)
  python.call("send_gcode",Dev_file)
  
  ## core gcode
  fileConn<-file(Dev_file)
  writeLines(Dev_gcode()[[2]], fileConn)
  close(fileConn)
  for(i in seq(input$Dev_repeat)){
    python.call("send_gcode",Dev_file)
  }
  
  ## end gcode
  fileConn<-file(Dev_file)
  writeLines(Dev_gcode()[[3]], fileConn)
  close(fileConn)
  python.call("send_gcode",Dev_file)
})
output$Dev_infoGcode = renderUI({
  tagList(
    h6(paste0(Dev_nbr_band()," bands")), ## need number of nozzle fired and position fired
    h6(paste0(paste0("Number of nozzles fired: ",sum(Dev_bitmap_a())*input$Dev_I))),
    h6(paste0("Number of positions fired: ",sum(as.logical(Dev_bitmap_b()))))
  )
  
})
output$Dev_plot <- renderPlot({
  plot(c(1,100),c(1,dim(Dev_bitmap_a())[1]),type="n",xlim=c(100,0),xlab="X",ylab="Y",main="Origin in upper right corner",sub="the origin is not the same as usual, I must fix it")
  rasterImage(1-apply(Dev_bitmap_a(),c(1),mean),xleft = input$Dev_dist_bottom,xright=input$Dev_dist_bottom+0.5,ybottom = 1,ytop=dim(Dev_bitmap_a())[1])
})
Dev_gcode <- reactive({
  start_gcode = c("G28 X0; home X axis",
                  "G28 Y0; home Y axis",
                  "G21 ; set units to millimeters",
                  "G90 ; use absolute coordinates",
                  paste0("G1 F",60*input$Dev_speed," ; set speed in mm per min for the movement"),
                  paste0("G1 X",input$Dev_dist_bottom," ; go in X position")
  )
  end_gcode = c("G28 X0; home X axis",
                "G28 Y0; home Y axis",
                "M84     ; disable motors")
  
  b=Dev_bitmap_b()
  
  list(start_gcode,b_to_gcode_X_fix(b,c(),c(),I=input$Dev_I,L=input$Dev_L),end_gcode)
})
output$Dev_gcode <- renderDataTable({
  data.frame(gcode = Dev_gcode()[[2]])
},options = list(pageLength = 10))