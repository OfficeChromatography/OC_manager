OC_manager
===========

Shiny app to operate apparatus of office chromatography

## Dependencies


### R

Download and install R:
http://cran.r-project.org/


R packages, possible missing package, please tell us.

```r
install.packages('devtools')
devtools::install_github('DimitriF/DLC')
devtools::install_github("rhandsontable","jrowen")
install.pacakges("serial")
install.packages("reticulate")
install.packages("DT")
```

### Python

Download and install python 2.7 (version superior to 2.7.10):
https://www.python.org/downloads/

Install PySerial

```python
pip -m install PySerial

```
## Run

From the folder (use `setwd()`) 

```r

shiny::runApp()
```

