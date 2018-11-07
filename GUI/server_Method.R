########## METHOD #############################################
# load control variable
Method = reactiveValues(control=list(),settings=list(),selected = 1)
METHOD_DIR='method/rdata/'
steps_choices = dir("tables/",pattern=".csv") %>% gsub(x=.,pattern=".csv",replacement="")
Method_feedback = reactiveValues(text="No feedback yet")
# load UI
source("./GUI/method/ui.R", local=T)

#load event Handler
source("./GUI/method/eventHandler.R", local=T)


#############Methods#####################################

#-------sample application --------------
# load UI
source("./GUI/method/methods/sample_application/ui.R", local=T)

#load event Handler
source("./GUI/method/methods/sample_application/eventHandler.R", local=T)

#load driver
appl_driver = ocDriver$get_sample_application_driver()

