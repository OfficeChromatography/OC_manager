## config.R file for OC_manager

## change here for the python version
# use_python("/usr/bin/python3.5", required = T)

login = T ## change to F to enable login, the admin password is "hptlc" by default.

board = F ## set to T for development purpose if you are not connected to the arduino
# pulse_delay_secu = T ## delay max of 20 microseconds for inkjet pulse delay

Drop_vol = 0.15 # in nL, use to calculate volume in Methods

Visu_roi = "0.25,0.2,0.6,0.6"
