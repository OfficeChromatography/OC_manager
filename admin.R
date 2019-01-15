## admin.R file for OC_manager

# to install R on the RPI:
# http://raspberrypi.stackexchange.com/questions/41226/getting-the-latest-version-of-r-on-the-raspberry-pi

shiny::runApp("/home/clau/MEGA/OC/Software/OC_manager",launch.browser = T,host = "0.0.0.0",port=5570)

# shiny::runApp("/home/clau/Documents/Dropbox_true/Dropbox/OC/Com/SiteWeb/shiny version/OC-Lab/",launch.browser = T)

# system("sudo scp -r /home/clau/Documents/Dropbox_true/Dropbox/OC/Software/OC_manager pi@192.168.0.103:/home/pi")
# system("sudo scp -r /home/clau/Documents/Dropbox_true/Dropbox/OC/Software/OC_manager pi@134.176.158.78:/home/pi")
# system("sudo scp -r /home/clau/Documents/Dropbox_true/Dropbox/OC/Software/OC_manager pi@134.176.158.83:/home/pi")
# system("sudo scp -r /home/clau/Documents/Dropbox_true/Dropbox/OC/Software/OC_manager pi@134.176.158.70:/home/pi")
# system("sudo scp -r /home/clau/Documents/Dropbox_true/Dropbox/OC/Software/OC_manager pi@134.176.232.59:/home/pi")
# system("sudo scp -r /home/clau/Documents/Dropbox_true/Dropbox/OC/Software/OC_manager pi@192.168.1.24:/home/pi")
  # system("sudo rsync -a -v /home/clau/MEGA/OC/Software/OC_manager/ pi@134.176.158.84:/home/pi/OC_manager/")


## scan local network:
# nmap -sP 192.168.1.0/24

#### Save image
## use disk to get the image name: sdx
### save image
##  dd if=/dev/mmcblk0 | gzip > /home/clau/Dropbox/RPI_OC_20170613.gz
### restore image
## gzip -dc /home/clau/Dropbox/RPI_OC_30122016.gz | dd of=/dev/sdx
## gzip -dc /home/clau/Dropbox/RPI_robot_26022017.gz | dd of=/dev/sdb
## sudo dd bs=4M of=/dev/mmcblk0 if=~/Documents/raspbian_32A.img
## gzip -dc /home/clau/Dropbox/RPI_OC_20170613.gz | dd of=/dev/mmcblk0
## gzip -dc /home/clau/Dropbox/RPI_OC_20170613.gz | sudo dd bs=4M status=progress of=/dev/sdb
## sudo dd bs=4M of=/dev/sdb status=progress if=/home/clau/Dropbox/RPI_OC_20170613


## Update the pi

# sudo apt-get update
# sudo apt-get upgrade
