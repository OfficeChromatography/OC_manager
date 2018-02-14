# message('library paths:\n', paste('... ', .libPaths(), sep='', collapse='\n'))

# chrome.portable = file.path(getwd(),
#                             'GoogleChromePortable/App/Chrome-bin/chrome.exe')

# launch.browser = function(appUrl, browser.path=chrome.portable) {
#   browser.path = chartr('/', '\\', browser.path)
#   message('Browser path: ', browser.path)
#   
#   CMD = browser.path
#   ARGS = sprintf('--app="%s"', appUrl)
#   
#   system2(CMD, args=ARGS, wait=FALSE)
#   NULL
# }
library(reticulate)
use_python("C:/Python27", required = FALSE)
shiny::runApp(launch.browser=T)
