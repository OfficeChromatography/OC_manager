# eat_table_heating = 
function(step){
  # eat_table_heating function V011,24 february 2017
  # very simple anyway, home, start heating, and wait the needed time, then home again
  # extract the needed information
  table = step$table
  Temperature=table[table[,1] == "Temperature",2];Time=table[table[,1] == "Time",2]
  
  gcode = c("G28 X0; home X axis",
            "G28 Y0; home Y axis",
            paste0("M190 S",Temperature," ; set temperature, wait to reach, use M140 to set and go to the next one"),
            paste0("G4 s",Time*60," ; time wait in secondes"),
            "M190 S0 ; set temperature off",
            "G28 X0; home X axis",
            "G28 Y0; home Y axis"
  )
  
  plot_step=function() {
    plot(c(1),c(1),type="n",main="No plot for heating step")
  }
  
  # replace the parts
  step$gcode = gcode
  step$plot = plot_step
  step$info = "still not but incomming"
  return(step)
}