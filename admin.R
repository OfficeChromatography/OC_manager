## admin.R file for OC_manager

# to install R on the RPI:
# http://raspberrypi.stackexchange.com/questions/41226/getting-the-latest-version-of-r-on-the-raspberry-pi

shiny::runApp("/home/clau/MEGA/OC/Software/OC_manager",launch.browser = T,host = "0.0.0.0",port=5570)
shiny::runApp(launch.browser = T,host = "0.0.0.0",port=5571)

# shiny::runApp("/home/clau/Documents/Dropbox_true/Dropbox/OC/Com/SiteWeb/shiny version/OC-Lab/",launch.browser = T)

# system("sudo scp -r /home/clau/Documents/Dropbox_true/Dropbox/OC/Software/OC_manager pi@192.168.0.103:/home/pi")
# system("sudo scp -r /home/clau/Documents/Dropbox_true/Dropbox/OC/Software/OC_manager pi@134.176.158.78:/home/pi")
# system("sudo scp -r /home/clau/Documents/Dropbox_true/Dropbox/OC/Software/OC_manager pi@134.176.158.83:/home/pi")
# system("sudo scp -r /home/clau/Documents/Dropbox_true/Dropbox/OC/Software/OC_manager pi@134.176.158.70:/home/pi")
# system("sudo scp -r /home/clau/Documents/Dropbox_true/Dropbox/OC/Software/OC_manager pi@134.176.232.59:/home/pi")
# system("sudo scp -r /home/clau/Documents/Dropbox_true/Dropbox/OC/Software/OC_manager pi@192.168.1.24:/home/pi")
# system("sudo rsync -a -v /home/clau/MEGA/OC/Software/OC_manager/ pi@134.176.158.85:/home/pi/OC_manager/")

## image copy
# rsync -a -v pi@134.176.158.85:/home/pi/OC_manager/www/pictures  /home/clau/MEGA/OC/data/Visu_rpi/pictures_bis

## change secu before !!!
# sudo rsync -a -v /home/clau/MEGA/OC/Software/OC_manager/  dimitri@134.176.7.66:/srv/shiny-server/OC_manager


## scan local network:
# nmap -sP 192.168.1.0/24

#### Save image
## use disk to get the image name: sdx

### save image
##  dd if=/dev/mmcblk0 | gzip > /home/clau/Dropbox/RPI_OC_20170613.gz
# dd if=/dev/mmcblk0 of=/home/clau/Dropbox/RPI_OC_20180213 status=progress
# dd if=/dev/mmcblk0 of=/home/clau/Dropbox/dietpi_OC_20180214 status=progress
# dd if=/dev/mmcblk0 of=/home/clau/Dropbox/dietpi_OC_20180215.img status=progress

### restore image, try to use etcher as GUI
## gzip -dc /home/clau/Dropbox/RPI_OC_30122016.gz | dd of=/dev/sdx
## gzip -dc /home/clau/Dropbox/RPI_robot_26022017.gz | dd of=/dev/sdb
## sudo dd bs=4M of=/dev/mmcblk0 if=~/Documents/raspbian_32A.img
## gzip -dc /home/clau/Dropbox/RPI_OC_20170911.gz | sudo dd status=progress of=/dev/mmcblk0
## gzip -dc /home/clau/Dropbox/RPI_OC_20170613.gz | sudo dd bs=4M status=progress of=/dev/sdb
## sudo dd bs=4M of=/dev/sdb status=progress if=/home/clau/Dropbox/RPI_OC_20170613
## sudo dd bs=4M of=/dev/mmcblk0 status=progress if=/home/clau/Dropbox/RPI_OC_20170613
# dd of=/dev/mmcblk0 if=/home/clau/Dropbox/RPI_OC_20180213 status=progress
## dd of=/dev/mmcblk0 if=/home/clau/Dropbox/ status=progress
# dd of=/dev/mmcblk0 if=/home/clau/Dropbox/dietpi_OC_20180214 status=progress

## shrink inmage
# https://softwarebakery.com/shrinking-images-on-linux
# sudo losetup -f ## request new loopback device
# sudo losetup /dev/loop0 myimage.img ## create device on image
# sudo partprobe /dev/loop0 ## access it
# sudo gparted /dev/loop0 ## resize it, not too small to avoid error
# sudo losetup -d /dev/loop0 ## detach
# sudo fdisk -l myimage.img ## access size
# sudo truncate --size=$[(9181183+1)*512] myimage.img

## shrink image bis:
# http://www.knight-of-pi.org/how-to-shrink-raspberry-pi-sd-card-images-with-gparted-and-dd/
# resize with gparted then use the count option to only take 3 giga...
# sudo dd if=/dev/mmcblk0 of=/home/clau/Dropbox/RPI_OC_20180605.img status=progress bs=1M count=3000


## deshrink it back
# http://dietpi.com/phpbb/viewtopic.php?f=12&t=298

## Update the pi

# sudo apt-get update
# sudo apt-get upgrade
