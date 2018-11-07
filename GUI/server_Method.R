# load control variable
Method = reactiveValues(control=list(),settings=list(),selected = 1)
METHOD_DIR='method/rdata/'

# load UI
source("./GUI/method/ui.R", local=T)

#load event Handler
source("./GUI/method/eventHandler.R", local=T)
