## config.R file for OC_manager


board = F ## set to T for development purpose if you are not connected to the arduino
pulse_delay_secu = T ## delay max of 20 microseconds for inkjet pulse delay

steps_choices = dir("tables/") %>% gsub(x=.,pattern="_table.csv",replacement="")
# steps_choices = c("Scan_dart")

Drop_vol = 0.15 # in nL

## need Y and X bias also but we see this later