OC_manager
===========

Shiny app to operate apparatus of office chromatography.

![OC_manager screenshot](OC_manager.png)

## Installation

In fine, we want to directly supply a RPI image, in the mean time you will have to go through the installation manually.

### Dependencies

Some dependencies can be missing, feedback are welcome. 

### Linux 

```
sudo apt-get install libtiff5-dev libssl-dev libcurl4-openssl-dev git

```

### R

Download and install R:
http://cran.r-project.org/


launch R with sudo and install the R packages, possible missing package, please tell us.

```
install.packages('devtools')
devtools::install_github('DimitriF/DLC')
devtools::install_github("rhandsontable","jrowen")
install.packages("serial")
install.packages("reticulate")
install.packages("DT")
install.packages("shinyBS")
install.packages("shinyalert")
```


For DLC, the package rgl could be a problem and can be installed from the CLI:

```
sudo apt-get install r-cran-rgl
```

### Python

Python3 should be installed by default in all linux system, the serial library is necessary though.

```
sudo apt-get install python3-serial
```

Also in the ```config.R``` file, you may need to change the python version. Use ```whereis python3``` from the command line to find the version of your system.


### Clone the repo

```
git clone https://github.com/DimitriF/OC_manager.git
```

The repo must have the following path: /home/pi/OC_manager

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

