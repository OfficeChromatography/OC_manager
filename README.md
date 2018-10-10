OC_manager Snapshot Dimitri Fichou (May 17, 2018)
==================================================

Shiny app to operate apparatus of office chromatography.

![OC_manager screenshot](OC_manager.png)

## Raspberry pi image

Follow [this link](https://jlubox.uni-giessen.de/getlink/fiLFUwBzvcCbUtiws9tct3df/RPI_OC_20180605.img.gz) to download an image of rasbian with the OC_manager set-up, last update: 20180605.

## Manual Installation

This procedure was tested on rasbian lite and desktop, downloaded 05-04-2018.

## First opening

expand file system

enable camera, ssh, vnc, gpio, i2c

set wifi passwd or static IP

```
sudo apt-get update
sudo apt-get upgrade
sudo reboot
```

## Installation script

This will download the installation script and exectute it.

```
wget  -P /home/pi/Documents/ https://github.com/DimitriF/OC_manager/raw/snapshot-dimitri-2018-05-17/oc-manager-install.sh
bash Documents/oc-manager-install.sh |& tee Documents/oc-install.txt
```


## Clone this github repository

```
git clone https://github.com/OfficeChromatography/OC_manager.git
```

## Checkout the snapshot branch

```
git checkout snapshot-dimitri-2018-05-17 
```



## Run

### Started at reboot with crontab (the best)

Crontab is a job scheduler for UNIX-like system. The file can be accessed with the following commands and the lines inside will be executed at the appropriate moment.

```
sudo crontab -e
```

Once in the editor, add this line which will launch the application at reboot, if the static IP had been set, the application will be available at the IP of the raspberry pi:

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

