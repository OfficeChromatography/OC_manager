########## METHOD #############################################
# load control variable
Method = reactiveValues(control=list(),selected = 1)
METHOD_DIR='method/method_to_load/'
Method_feedback = reactiveValues(text="No feedback yet")
# enviroment for methods
ui_methods <<- new.env()
eventHandler_methods <<- new.env()
appl_driver = ocDriver$get_sample_application_driver()
# load UI
source("./GUI/method/ui.R", local=T)

#load event Handler
source("./GUI/method/eventHandler.R", local=T)
