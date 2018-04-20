---
output:
  html_document: default
  pdf_document: default
---
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


launch R and install the R packages, possible missing package, please tell us.

```
install.packages('devtools')
devtools::install_github('DimitriF/DLC')
devtools::install_github("rhandsontable","jrowen")
install.packages("serial")
install.packages("reticulate")
install.packages("DT")
install.packages("shinyBS")
```

### Python

Python should be installed by default in all linux system, the serial library is necessary though

```
sudo apt-get install python-serial
```

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

A pdf is available in the folder ```Doc``` and should cover basic usage.

For implementing a new method, a pdf is also available in the same folder.

