#! /bin/bash
echo "****************************"
echo "INSTALLING PYTHON AND FRIENDS"
echo "****************************"
mydir="${0%/*}"
echo $mydir
yes | sudo apt-get install python3
yes | sudo apt-get install virtualenv
python3 -m venv "$mydir/py_virtual_env"
source "$mydir/py_virtual_env/bin/activate"
pip install -r "$mydir/requirements.txt"
