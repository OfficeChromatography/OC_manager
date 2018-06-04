## eat_table documentation
# this one is a bit special as we don't produce gcode but just update the pict_table object

function(step){
  table = step$table
  nbr_pict=table[table[,1] == "nbr_pict",2]
  
  if(is.null(step$appli_table)){## create original table
    step$appli_table = data.frame(Exposure = rep(100,nbr_pict),ISO = rep(100,nbr_pict),Light = rep("Red",nbr_pict))
  # }else if(nrow(step$appli_table) < nbr_pict){## modify table length
  #   step$appli_table = rbind(
  #     step$appli_table,
  #     data.frame(Exposure = rep(100,nbr_pict),ISO = rep(100,nbr_pict),Light = rep("Red",nbr_pict))
  #   )[seq(nbr_pict),]
  # }else if(nrow(step$appli_table) > (nbr_pict)){## modify table length
  #   step$appli_table = step$appli_table[seq(nbr_pict),]
  }
  step$appli_table$Light = factor(step$appli_table$Light,levels = c("Red","Green","Blue","White","254 nm")) ## for rhansontable modif
  
  plot_step=function() {
    plot(c(1),c(1),type="n",main="No plot for documentation step")
  }
  
  # replace the parts
  step$plot = plot_step
  # step$appli_table = appli_table
  return(step)
}