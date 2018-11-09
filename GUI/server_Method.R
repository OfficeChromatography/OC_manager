########## METHOD #############################################
# load control variable
Method = reactiveValues(control=list(),selected = 1)
METHOD_DIR='method/method_to_load/'
Method_feedback = reactiveValues(text="No feedback yet")
# enviroment for methods
appl_driver = ocDriver$get_sample_application_driver()

#load event Handler
source("./GUI/method/eventHandler.R", local=T)
# load UI
source("./GUI/method/ui.R", local=T)
