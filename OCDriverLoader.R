library(stringi)


use_virtualenv(file.path(getwd() ,"oc_driver", "py_virtual_env"), required=T)
ocdriverPackage <- import_from_path("OCDriver", path='oc_driver', convert = TRUE)
ocDriver <- ocdriverPackage$OCDriver() # use default config


toRSettingsTableFormat <- function(pythonDict, labels, units){
    valuesWithSpaces = as.matrix(stack(pythonDict))[, c(2, 1)][, "values"]
    values = stri_replace_all_charclass(valuesWithSpaces, "\\p{WHITE_SPACE}", "")
    f = data.frame(values, units, stringsAsFactors = FALSE)
    rownames(f) = labels
    return (f)
}


settingsTabletoPythonDict  <- function(settingsTable, pythonKeys){
    values = settingsTable[["values"]]
    return (py_to_r(py_dict(pythonKeys, values)))

}


bandConfToRSettingsTableFormat  <- function(bandConf){
    labels = c("approx. Band Start [mm]","Drop Volume [nl]","approx. Band End [mm]","Volume Set [µl]","Nozzle Id", "Volume Real [µl]", "Label")
    fUntransposed = as.data.frame(matrix(unlist(bandConf), nrow=length(unlist(bandConf[1]))))
    f = t(fUntransposed)
    colnames(f) = labels
    sortedFrame = f[, c(7, 5, 2, 4, 6, 1, 3)]
    rownames(sortedFrame) = c()
    return (sortedFrame)

}


bandConfSettingsTableFormatToPython  <- function(settingsFormat){
    keys = c("label", "nozzle_id","drop_volume","volume_set", "volume_real", "start", "end")
    bandlist = c()
    for (row in 1:nrow(settingsFormat)){
        rowValues = settingsFormat[row,]
        band = py_to_r(py_dict(keys, rowValues))
        bandlist[[row]] = band
    }
    return (bandlist)
}
