## Documentation exec
function(step,Plate){
  ## Go in position
  main$send_gcode("gcode/Visu_position.gcode")
  # print("gcode/Visu_position.gcode")
  appli_table = step$appli_table
  ## remove duplicate
  appli_table = appli_table[!duplicated(appli_table),]
  ## start loop
  withProgress(message = "Processing", value=0,min=0,max=nrow(appli_table)+1, {
    path = paste0("www/pictures/",format(Sys.time(), "%Y%b%d_%H_%M_%S_"),Plate)
    dir.create(path)
    incProgress(1,message="Directory created")
    for(i in seq(nrow(appli_table))){
      ## set light
      Light = appli_table[i,"Light"]
      main$send_gcode(paste0("gcode/",appli_table[i,"Light"],".gcode"))
      # print(paste0("gcode/",Light,".gcode"))
      
      ## take the picture
      ISO = appli_table[i,"ISO"];if(ISO==0){ISO="auto"}
      exp = appli_table[i,"Exposure"];if(exp==0){exp="auto"}
      Visu_file = paste0(path,"/",exp,"ms_iso_",ISO,"_",Light,".jpg")
      command = paste0("raspistill "," -n "," -roi ",Visu_roi," -w 2000 -h 2000") 
      if(ISO != "auto"){
        command = paste0(command,"  -ISO ",ISO)
      }
      if(exp != "auto"){
        command = paste0(command," -ss ",exp,"000")
      }
      command = paste0(command," -o ",Visu_file)
      system(command)
      # print(command)
      incProgress(1,message=command)
    }
  })
  
}