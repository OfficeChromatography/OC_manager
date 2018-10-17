## server_Method.R
#-----------------------------------------------------------------------------------
# function
#-------------------------------------------------------------------------------------
##Variable
steps_choices = dir("tables/",pattern=".csv") %>% gsub(x=.,pattern=".csv",replacement="")
Method_feedback = reactiveValues(text="No feedback yet")


#-----------------------------------------------------------------------------------------

## methods
observeEvent(input$Method_step_add,{
    print("Method_step_add")
    step = length(Method$control)+1
  data = read.table(paste0("tables/",input$Method_step_new,".csv"),header=T,sep=";")
  Method$control[[step]] = list(type=input$Method_step_new,
                                table=data,                          
                                gcode = NULL,
                                info = "Update to see the info",
                                Done = F)
  Method$settings[[step]]=list(type=input$Method_step_new,
                               table=data)
  if(input$Method_step_new == "Documentation"){ ## pict table, special for Documentation
    nbr_pict=data[data[,1] == "nbr_pict",2]
    Method$control[[step]]$exec = source("eat_tables/Documentation_exec.R")$value
  }
  Method_feedback$text = paste0("Step ",input$Method_step_new," added")
  Method$selected = length(Method$control)
})

observeEvent(input$Method_step_delete,{
    print("Method_step_delete")
    if(length(Method$control) == 0){
    shinyalert(title = "stupid user",text = "no step to delete",type="error",closeOnClickOutside = T, showCancelButton = F)
  }else{
    Method_feedback$text = paste0("Step ",input$Method_steps," deleted")
    Method$control[[as.numeric(input$Method_steps)]] = NULL
    Method$settings[[as.numeric(input$Method_steps)]] = NULL
    Method$selected = 1
  }
  
})

observeEvent(input$Method_steps,{
    print("Method_steps")
    step <- as.numeric(input$Method_steps)
  if(step > 0){
    path=paste0("eat_tables/",Method$control[[step]]$type,".R")
    source(path)
    Method$control[[step]]$appli_table=appli_Table(Method$control[[step]])
    Method$settings[[step]]$appli_table=Method$control[[step]]$appli_table
    Method$control[[step]]$gcode=generate_gcode(Method$control[[step]])
  }
})



## start
observeEvent(input$Method_step_exec,{
    print("Method_step_exec")
    step = as.numeric(input$Method_steps)
  if(Method$control[[step]]$type != "Documentation"){
      # read the gcode
      Method_file = paste0("gcode/","Method",".gcode")
      Log = Method_file
      fileConn<-file(Method_file)
      writeLines(Method$control[[step]]$gcode, fileConn)
      close(fileConn)
      # put it in the log
      write(paste0(format(Sys.time(),"%Y%m%d_%H:%M:%S"),";",Method$control[[step]]$type,";",Log,";",Log,";",connect$Visa,";",input$Plate),file="log/log.txt",append = T)
      gcode_sender$send_gcode(Method_file, printer)
	
      Method_feedback$text = paste0("Step ",input$Method_steps," started")
    }else{
      Method$control[[step]]$exec(Method$control[[step]],input$Plate,main)
    }
})


output$Method_gcode_download <- downloadHandler(
  filename = function(x){paste0("OC_Lab_",
                                Method$control[[as.numeric(input$Method_steps)]]$type,
                                "_",
                                paste0(Method$control[[as.numeric(input$Method_steps)]]$table[,2],collapse = "_"),
                                '.gcode')},##"OC_manager.gcode",
  content = function(file) {
    Method_file = paste0("gcode/","Method",".gcode")
    Log = Method_file
    fileConn<-file(Method_file)
    writeLines(Method$control[[as.numeric(input$Method_steps)]]$gcode, fileConn)
    close(fileConn)
    file.copy(paste0("gcode/","Method",".gcode"), file)
  }
)
## save

observeEvent(input$Method_save,{
    print("Method_save")
    if(paste0(input$Method_save_name,".Rdata") %in% dir(METHOD_DIR)){
    shinyalert(title = "Method exist",text = "Overwrite",type="warning",closeOnClickOutside = T, showCancelButton = T,
               callbackR = function(x){
                 if(x != FALSE){
                   withProgress(message = "Processing", value=0, {
                     settings = Method$settings
                     save(settings,file=paste0(METHOD_DIR,input$Method_save_name,".Rdata"))
                     Method_feedback$text = paste0("Method ",input$Method_save_name," saved")
                   })
                   updateSelectizeInput(session,"Method_load_name",choices=dir(METHOD_DIR))
                 }else{
                   Method_feedback$text = paste0("Method ","not"," saved")
                 }
               })
  }else{
    withProgress(message = "Processing", value=0, {
      settings = Method$settings
      save(settings,file=paste0(METHOD_DIR,input$Method_save_name,".Rdata"))
      Method_feedback$text = paste0("Method ",input$Method_save_name," saved")
    })
    updateSelectizeInput(session,"Method_load_name",choices=dir(METHOD_DIR))
  }
  
})
observeEvent(input$Method_load,{
    print("Method_load")
    withProgress(message = "Processing", value=0, {
      load(paste0(METHOD_DIR,input$Method_load_name))
    Method$settings = settings
    for (step in 1:length(settings)){
      Method$control[[step]] = list(type= Method$settings[[step]]$type,
                            table=Method$settings[[step]]$table,
			    appli_table=Method$settings[[step]]$appli_table,
                            gcode = NULL,
                            info = "Update to see the info",
                            Done = F)
    }
    Method$selected = 1
    Method_feedback$text = paste0("Method ",input$Method_load_name," loaded")
    updateTextInput(session, "Method_save_name", value = gsub(pattern = ".Rdata",replacement = "",x = input$Method_load_name))
  })
})



observeEvent(input$Method_step_update,{
    print("Method_step_update")
  step = as.numeric(input$Method_steps)
  #update Settings
  data = hot_to_r(input$Method_step_option)
  Method$settings[[step]]$table=data
  Method$control[[step]]$table=data
  #update applied table 
  data=hot_to_r(input$Method_step_appli_table)
  Method$settings[[step]]$appli_table=data
  Method$control[[step]]$appli_table=data
  ## eat tables
  ## evaluateSelectedStep(steps)
  ## if type == Sample then sample$
  ##  myFunction = source(myFunction.R)
  ##
  withProgress(message = "Processing", value=0, { 
    path=paste0("eat_tables/",Method$control[[step]]$type,".R")
    source(path)
    Method$control[[step]]$appli_table=appli_Table(Method$control[[step]])
    Method$control[[step]]$gcode=generate_gcode(Method$control[[step]])
    
  })
  Method$selected = input$Method_steps
  Method_feedback$text = paste0("Step ",input$Method_steps," updated")
})




