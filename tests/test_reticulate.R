# ## test reticulate
# 
# library(reticulate)
# py_run_file("setup.py")
# # main_py <- py_run_string("x = y")
# # main_py$x
# 
# main_py = py_run_string("connect_board('/dev/ttyACM0')")
# 
# main_py = py_run_string("send_cmd('G28 Y0')")


## test no python
# f <- file("/dev/ttyACM0", open="r")

library(serial)
s = open(con, ...)