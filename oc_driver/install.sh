#! /bin/bash
echo "****************************"
echo "INSTALLING PYTHON AND FRIENDS"
echo "****************************"
mydir="${0%/*}"
echo ""
echo " ~~~~ INSTALLING PYTHON 2.7"
echo ""
yes | sudo apt-get install python2.7
echo ""
echo " ~~~~ DOWNLOADING PIP"
echo ""
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
echo ""
echo " ~~~~ INSTALLING PIP"
echo ""
yes | sudo python2.7 get-pip.py
yes | sudo python2.7 -m pip install virtualenv
python2_path=$(which python2.7)
echo ""
echo " ~~~~ INSTALLING VIRTUALENV"
echo ""
yes | virtualenv -p $python2_path "$mydir/py_virtual_env"
source "$mydir/py_virtual_env/bin/activate"
pip install -r "$mydir/requirements.txt"
echo ""
echo "Cleaning..."
echo "get-pip.py"
rm "get-pip.py"
echo ""
echo "... Done!"
echo ""
