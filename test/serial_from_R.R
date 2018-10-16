## test arduino connection without python

# library(serial)
# #listPorts()
# port = dir("/dev",pattern = "ttyACM")
# 
# s = serialConnection(name = "testcon",port = port, mode = "115200,n,8,1",
#                  buffering = "none", newline = 0, eof = "", translation = "lf",
#                  handshake = "none", buffersize = 4096)
# 
# #serial::read.serialConnection(s)
# open(s)
# serial::isOpen(s)
# 
# read.serialConnection(s)
# write.serialConnection(s,"M42 P63 S255")
# 
# close(s)


f <- file(dir("/dev",pattern = "ttyACM",full.names = T), open="r+")

write("M42 P63 S255",file = f)
scan(f,n=1, quiet=F,what = "character",sep="\n")
write("M42 P63 S0",file = f)
scan(f,n=1, quiet=F,what = "character")

close(f)


gcode = read.csv("gcode/LED.gcode",header=F)
gcode = as.vector(gcode)
f <- file(dir("/dev",pattern = "ttyACM",full.names = T), open="r+")
write("M110",file=f)
readLines(f)
for(i in seq(nrow(gcode))){
  # "N" + str(lineno) + " " + command
  write(as.character(gcode[i,]),file=f)
  # print(gcode[i,])
  # while(scan(f,n=1, quiet=F,what = "character",sep="\n") != "ok"){
  # r = NULL
  r = readLines(f)
  while(length(r) == 0){
    r = readLines(f)
    print(r)
    Sys.sleep(0.1)
  }
}
close(f)


