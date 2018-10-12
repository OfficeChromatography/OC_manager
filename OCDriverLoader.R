use_virtualenv("./oc_driver/py_virtual_env", required=T)
ocdriverPackage <- import_from_path("OCDriver", path='oc_driver', convert = TRUE)
connectionString =  "/dev//ttyACM0"
baudRate = 115200
ocDriver <- ocdriverPackage$OCDriver(connectionString, baudRate)
