# OC DRIVER: kann aus configs OC-HW ansteuern
# beinhaltet GCODE translator (config) -> gcode
# ACHTUNG er kann keine R tabelle verstehen! :)

# ' main () {
#   # source(ocDriver.R, local=T)
#   
#   # config = extractConfigFromTable(table)
#   # ocDriver.sampleApplication(config)
#   # ocDriver intern: gcode  = createGCODEFromConfig(config)
# 
# 
# }'


# generates Table withe applied volume
appli_Table<-function(step){
  
  #getting infos
  table = step$table
  band_length = table[table[,1] == "Band length [mm]",2]
  nbr_band = table[table[,1] == "Number of bands",2]
  I= table[table[,1] == "Number of Fire",2]

  #applied Volumn per band
  Vol_band=band_length/reso*I*Drop_vol/1000
  ## create original table |nozzle | Vol_set | Vol_real
  if(is.null(step$appli_table)){
    appli_table = data.frame(nozzle=rep(1,nbr_band), Vol_set=rep(Vol_band,nbr_band), Vol_real=rep(Vol_band,nbr_band), unit=rep("µL",nbr_band))
  }
  else
    {
      appli_table=step$appli_table
      tablelength=nrow(step$appli_table)
      for (i in 1:tablelength)
      {
        appli_table$Vol_real[i]=round(appli_table$Vol_set[i]/Vol_band,0)*Vol_band
      }
      diffRows=nbr_band -tablelength
      ## modify table length
      if(diffRows>0)
      {
      appli_table=rbind(appli_table,
                        data.frame(nozzle=rep(1,diffRows), Vol_set=rep(Vol_band,diffRows), Vol_real=rep(Vol_band,diffRows), unit=rep("µL",diffRows))
      			)
}
      else if(diffRows<0)
      {
      appli_table = step$appli_table[seq(nbr_band),]
      }
    }    
  rownames(appli_table) = seq(nrow(appli_table))
  
  return(appli_table)
}
# applicationSampler = ocDriver.createGCODEForSampleApplication(table) : object
# applicationSampler.run()

# TODO: extract table data in encapsulated logic/func
# example:
# config = extractConfigFromTable(table)
# gcode  = createGCODEFromConfig(config)
#


# generates gcode for the Application  
generate_gcode<-function(step){  
  #getting infos
  table = step$table
  band_length = table[table[,1] == "Band length [mm]",2]
  # application position X == motor control Y
  dist_y = table[table[,1] == "First application position X [mm]",2]
  plate_y = table[table[,1] == "Plate X [mm]",2]   
  # application position Y == motor control X
  dist_x = table[table[,1] == "application position Y [mm]",2]
  plate_x = table[table[,1] == "Plate Y [mm]",2]
  gap = table[table[,1] == "Track distance [mm]",2]
  I= table[table[,1] == "Number of Fire",2]
  speed = table[table[,1] == "Speed [mm/s]",2]
  L=table[table[,1] == "Pulse delay [µs] (<20)",2]
  nbr_band = table[table[,1] == "Number of bands",2]


  ## deal with plate dimension
  dist_x = xlevel+dist_x + 50-plate_x/2
  dist_y = ylevel+dist_y + 50-plate_y/2
  

  #gcode start
  start_gcode = c("G28 X0",
                  "G28 Y0",
                  "G21",
                  "G90",
                  paste0("G1 F",60*speed),
                  paste0("G1 X",dist_x) 
  )
  #gcode end
  end_gcode = c("G28 X0",
                "G28 Y0",
                "M84 ")

  Vol_band=band_length/reso*I*Drop_vol/1000
  
  #course
  band_start=seq(from=dist_y,by=gap,length.out = nbr_band)
  band_end=seq(from=dist_y+gap,by=gap,length.out = nbr_band)
  nozzle= step$appli_table$nozzle
  repSpray=step$appli_table$Vol_real/Vol_band
  
  gcode=c()
  #gcode creator
  for (j in seq(nbr_band))
  {
    # calculate each nozzle as binary Code because of the gcode 
    #S= 3 -> 000000000011 -> nozzle 1 and 2 fire
    # nozzle 3 -> 000000000100 -> S= 4
    S = rep(0,12)
    for(l in seq(12)){if(l %in% as.numeric(nozzle[j])){S[l] = 1}};
    S=sum(2^(which(S== 1)-1))
    
    # shift because of selected nozzle
    shift = round((1 - nozzle[j])*reso,3)
    # gcode per band
    number_of_steps= band_length/reso
    gcode_band= c()
    for (i in seq(from=band_start[j]+shift, by=reso, length.out = number_of_steps))
    {
    gcode_band=c(gcode_band,paste0("G1 Y",i),                    # go in Position
                                  "M400",                        # wait until fire
                            paste0("M700 P0 I",I," L",L," S",S), # fire 
				  "M400")			 # wait
    }
    # repeat gcode per band to applie Vol_wish
    n=as.integer(repSpray[j])
    gcode=c(gcode,rep(gcode_band,n))
  }
  gcode=c(start_gcode,gcode,end_gcode)
  return(gcode)
}

# generates the information plot
plot_step<-function(step) {
  #getting infos
  table = step$table
  band_length = table[table[,1] == "Band length [mm]",2]
  dist_x = table[table[,1] == "First application position X [mm]",2]
  gap = table[table[,1] == "Track distance [mm]",2]
  dist_y = table[table[,1] == "application position Y [mm]",2]
  plate_y = table[table[,1] == "Plate Y [mm]",2]
  plate_x = table[table[,1] == "Plate X [mm]",2]    
  
  ## deal with plate dimension
  dist_x = dist_x + 50-plate_x/2
  dist_y = dist_y + 50-plate_y/2
  
  SA_table=step$appli_table
    plot(c(1,100),c(1,100),type="n",xaxt = 'n',xlim=c(0,100),ylim=c(100,0),xlab="",ylab="Application direction (X) ")
    axis(3)
    mtext("Migration direction (Y)", side=3, line=3)
    for(band in seq(nrow(SA_table))){
          segments(x0 = dist_y,
                   y0 = dist_x+(band-1)*gap,
                   y1 = dist_x+(band-1)*gap+band_length)
    }
    symbols(x=50,y=50,add = T,inches = F,rectangles = rbind(c(plate_y,plate_x)),lty=2)

}