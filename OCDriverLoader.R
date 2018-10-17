use_virtualenv(file.path(getwd() ,"oc_driver", "py_virtual_env"), required=T)
ocdriverPackage <- import_from_path("OCDriver", path='oc_driver', convert = TRUE)
ocDriver <- ocdriverPackage$OCDriver() # use default config
