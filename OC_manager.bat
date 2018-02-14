@echo off
SET ROPTS=--no-save --no-environ --no-init-file --no-restore --no-Rconsole
"C:\Program Files\R\R-3.4.3\bin\x64\Rscript.exe" %ROPTS% runShinyApp.R
