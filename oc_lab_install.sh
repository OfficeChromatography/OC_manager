#install script for OC_Lab
#!/bin/bash
echo""
echo "***********************************************************"
echo ""
echo "You are going to install OC-Lab-Lite on your Raspberry Pi."
echo ""
echo "Don't worry, this will take several hours!"
echo ""
echo "Are you ready to start? (y/n)"
read userinput
if [ "$userinput" == "y" ]; then
echo ""
echo "Installing r-base"
yes | sudo apt-get install r-base 
echo ""
echo "Installing libraries"
yes | sudo apt-get install libssl-dev libcurl4-openssl-dev r-cran-rgl libtiff5-dev python-serial git
yes | sudo apt-get install libssh2-1-dev
yes | sudo apt-get install libpython2.7
echo ""
echo "Removing packages not used anymore"
yes | sudo apt autoremove
echo ""
echo "Installing R packages"
yes | sudo su - -c "R -e \"install.packages('devtools', repos='http://cran.rstudio.com/')\""
yes | sudo su - -c "R -e \"devtools::install_github('rstudio/httpuv')\""
yes | sudo su - -c "R -e \"devtools::install_github('rstudio/shiny')\""
yes | sudo su - -c "R -e \"install.packages('serial', repos='http://cran.rstudio.com/')\""
yes | sudo su - -c "R -e \"install.packages('reticulate', repos='http://cran.rstudio.com/')\""
yes | sudo su - -c "R -e \"install.packages('DT', repos='http://cran.rstudio.com/')\""
yes | sudo su - -c "R -e \"install.packages('shinyBS', repos='http://cran.rstudio.com/')\""
yes | sudo su - -c "R -e \"install.packages('shinyalert', repos='http://cran.rstudio.com/')\""
yes | sudo su - -c "R -e \"devtools::install_github('rhandsontable','jrowen')\""
echo "Performing reboot"
sudo reboot
else 
echo "The installation was skipped."
fi


