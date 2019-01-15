## test script to test the eat table functions

source("eat_table.R")

for(i in c("Dev")){
  ## prep step list
  data = read.table(paste0("tables/",i,"_table.csv"),header=T,sep=";")
  Method = list(l=list(
    list(type=i,
         table=data,
         eat_table = eat_table[[i]],
         gcode = NULL,
         plot=function(){plot(x=1,y=1,type="n",main="Update to visualize")},
         info = "update to see the info",
         Done = F)
    )
  )
  if(i == "SA"){ ## special case for SA, or should we add it for Dev and Deriv also ??
    Method$l[[length(Method$l)]]$SA_table = data.frame(Band = seq(5),Value = paste0("volume_band_",seq(5)),Default = seq(5))
  }
  
  Method$l[[length(Method$l)]] = Method$l[[length(Method$l)]]$eat_table(Method$l[[length(Method$l)]])
}



