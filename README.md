OC_manager
===========

Shiny app to operate apparatus of office chromatography.

![OC_manager screenshot](OC_manager.png)

## Installation

In fine, we want to directly supply a RPI image, in the mean time you will have to go through the installation manually.

Tested on rasbian lite downloaded 05-04-2018

## First opening

expand file system

enable camera, ssh, vnc, gpio, i2c

set wifi passwd or static IP

```
sudo apt-get update
sudo apt-get upgrade
sudo reboot
```

## Dependencies

```
sudo apt-get install r-base 
sudo apt-get install libssl-dev libcurl4-openssl-dev r-cran-rgl libtiff5-dev python-serial git
sudo apt-get install libssh2-1-dev ## not sure about this one...
sudo apt-get install libpython2.7 ## may not be needed on classic raspbian
```

## R packages installation

```
sudo su - -c "R -e \"install.packages('devtools', repos='http://cran.rstudio.com/')\""
sudo su - -c "R -e \"devtools::install_github('rstudio/httpuv')\""
sudo su - -c "R -e \"devtools::install_github('rstudio/shiny')\""
sudo su - -c "R -e \"install.packages('serial', repos='http://cran.rstudio.com/')\""
sudo su - -c "R -e \"install.packages('reticulate', repos='http://cran.rstudio.com/')\""
sudo su - -c "R -e \"install.packages('DT', repos='http://cran.rstudio.com/')\""
sudo su - -c "R -e \"install.packages('shinyBS', repos='http://cran.rstudio.com/')\""
sudo su - -c "R -e \"install.packages('shinyalert', repos='http://cran.rstudio.com/')\""
sudo su - -c "R -e \"devtools::install_github('DimitriF/DLC')\""
sudo su - -c "R -e \"devtools::install_github('rhandsontable','jrowen')\""
sudo reboot
```

## Clone this github repository

```
git clone https://github.com/DimitriF/OC_manager.git
```

## Run

### Started at reboot with crontab (the best)

```
sudo crontab -e
```

Add this line in:

```
@reboot Rscript /home/pi/OC_manager/app_exec.R
```

### Directly from R (in case of problem to catch the errors)

From the folder (use `setwd()`) 

```r
shiny::runApp()
```

## Documentation

A pdf is available in the folder ```Instruction```.

For implementing a new method, a pdf is also available in the same folder.

