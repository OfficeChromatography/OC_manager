#install script for OC_Manager
#!/bin/bash
echo""
echo "***********************************************************"
echo ""
echo "You are going to install OC_Manger on your Raspberry Pi."
echo ""
echo "Don't worry, this will take several hours!"
echo ""
echo "Are you ready to start? (y/n)"
read userinput
if [ "$userinput" == "y" ]
then
  echo "Installing r-base"
  yes | sudo apt-get install r-base
  echo "Cloning later from git"
  git clone https://github.com/r-lib/later
  echo ""
  echo "modifying Makevars"
  sudo sed -i -f OC_manager/sed.cmd later/src/Makevars
  echo ""
  echo "Installing libraries"
  yes | sudo apt-get install libssl-dev libcurl4-openssl-dev r-cran-rgl libtiff5-dev python-serial git
  yes | sudo apt-get install libssh2-1-dev libboost-atomic-dev libxml2-dev
  yes | sudo apt-get install libpython2.7
  echo ""
  echo "Removing packages not used anymore"
  yes | sudo apt autoremove
  echo ""
  echo "Installing packages BH needed for 'later'"
  yes | sudo su - -c "R -e \"install.packages('BH', repos='http://cran.rstudio.com/')\""
  echo ""
  echo "Installing 'later'"
  yes | sudo R CMD INSTALL later
  echo ""
  echo "Installing R packages"
  echo ""
  yes | sudo su - -c "R -e \"install.packages('devtools', repos='http://cran.rstudio.com/')\""
  yes | sudo su - -c "R -e \"devtools::install_github('DimitriF/DLC')\""
  yes | sudo su - -c "R -e \"devtools::install_github('rstudio/httpuv')\""
  yes | sudo su - -c "R -e \"devtools::install_github('rstudio/shiny')\""
  yes | sudo su - -c "R -e \"devtools::install_github('rstudio/shinydashboard')\""
  yes | sudo su - -c "R -e \"install.packages('serial', repos='http://cran.rstudio.com/')\""
  yes | sudo su - -c "R -e \"install.packages('reticulate', repos='http://cran.rstudio.com/')\""
  yes | sudo su - -c "R -e \"install.packages('DT', repos='http://cran.rstudio.com/')\""
  yes | sudo su - -c "R -e \"install.packages('shinyBS', repos='http://cran.rstudio.com/')\""
  yes | sudo su - -c "R -e \"install.packages('shinyalert', repos='http://cran.rstudio.com/')\""
  yes | sudo su - -c "R -e \"devtools::install_github('jrowen/rhandsontable')\""
  echo ""
  echo "Performing reboot"
  sudo reboot
else
  echo "The installation was skipped"
fi
