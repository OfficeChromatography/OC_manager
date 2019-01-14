########## METHOD #############################################
# load control variable
Method <<- reactiveValues(control=list(),selected = 1)
Method_feedback <<- reactiveValues(text="No feedback yet")
#load event Handler
source("./GUI/method/eventHandler.R", local=T)
# load UI
source("./GUI/method/ui.R", local=T)
# load driver
sample_application_driver <<- ocDriver$get_sample_application_driver()
development_driver <<- ocDriver$get_development_driver()
documentation_driver <<- ocDriver$get_documentation_driver()
