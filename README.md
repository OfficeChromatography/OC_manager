OC_manager
===========

Shiny app to operate apparatus of office chromatography.

![OC_manager screenshot](OC_manager.png)

## Raspberry pi image

Follow [this link](https://jlubox.uni-giessen.de/dl/fiDjBMz6WyeJb9iZBq69QdxE/OC_manager_rpi_JLU-Box_Dimitri.zip) to download an image of rasbian with the OC_manager set-up, last update: 20180605.

You will need to setup the static IP to use OC_manager the way it was intented to be used (without screen). [This link](https://raspberrypi.stackexchange.com/questions/37920/how-do-i-set-up-networking-wifi-static-ip-address) should help.

Then you can access OC_manager from your web browser on the static IP you set as the software is served with a cronjob on port 80.

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
wget  -P /home/pi/Documents/ https://github.com/DimitriF/OC_manager/raw/master/oc-manager-install.sh
bash Documents/oc-manager-install.sh |& tee Documents/oc-install.txt
```


## Clone this github repository

```
git clone https://github.com/OfficeChromatography/OC_manager.git
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

