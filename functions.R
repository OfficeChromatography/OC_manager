## functions for OC_manager

BinToDec <- function(x) {sum(2^(which(x == 1)-1))}

DecToBin <- function(x){  rev(as.numeric(sapply(strsplit(paste(rev(intToBits(x))),""),`[[`,2)))[1:4]}

a_to_b = function(a){
  ## empty array
  inche = 25.4 # mm/inche
  dpi = 96
  reso = inche/dpi
  nozzle_X = 12;nozzle_Y = 1
  plate_X = 100;plate_Y=100
  X=floor(plate_X/reso/nozzle_X)*nozzle_X;Y=floor(plate_Y/reso/nozzle_Y)*nozzle_Y
  path=dim(a)[3]
  ## redim array
  b = array(0,dim=c(X/nozzle_X,Y,dim(a)[3]))
  for(i in seq(path)){
    for(j in seq(X/nozzle_X)){
      for(k in seq(Y/nozzle_Y)){
        b[j,k,i] = BinToDec(a[((j-1)*nozzle_X+1):(j*nozzle_X),k,i])
      }
    }
  }
  b
}


b_to_gcode = function(b,start_gcode,end_gcode,I=1,L=5){
  ## empty array
  inche = 25.4 # mm/inche
  dpi = 96
  reso = inche/dpi
  nozzle_X = 12;nozzle_Y = 1
  plate_X = 100;plate_Y=100
  X=floor(plate_X/reso/nozzle_X)*nozzle_X;Y=floor(plate_Y/reso/nozzle_Y)*nozzle_Y
  
  ## get coord
  coordonate = list(
    X = round(seq(from=reso*nozzle_X/2+reso/2,by=reso*12,length.out = dim(b)[1]),4),
    Y = round(seq(from=reso/2,by = reso,length.out = dim(b)[2]),4)
  )
  ## begin gcode
  gcode = start_gcode
  ## iterate
  for(k in seq(dim(b)[3])){ # slice loop, need modulo for next loop
    if(k %% 2 == 1){
      s = seq(dim(b)[1])
    }else{
      s = seq(dim(b)[1]) %>% rev
    }
    for(i in s){ # X loop, need modulo
      if(i %% 2 == 1){
        s = seq(dim(b)[2])
      }else{
        s = seq(dim(b)[2]) %>% rev
      }
      for(j in s){
        if(b[i,j,k] != 0){
          gcode = c(gcode,paste0("G1 Y",coordonate$X[i]," X",coordonate$Y[j]," ; go in position")) ## X and Y are inversed, carefull
          gcode = c(gcode,"M400 ; Wait for current moves to finish ")
          gcode = c(gcode,paste0("M700 P0 I",I," L",L," S",b[i,j,k]," ; Fire inkjet bits"))
        }
      }
    }
  }
  c(gcode,end_gcode)
}

b_to_gcode_X_fix = function(b,start_gcode,end_gcode,I=1,L=5,W=0){
  ## empty array
  inche = 25.4 # mm/inche
  dpi = 96
  reso = inche/dpi
  nozzle_Y = 12
  plate_Y=100
  Y=floor(plate_Y/reso/nozzle_Y)*nozzle_Y
  
  ## get coord
  coordonate = list(
    Y = round(seq(from=reso/2,by = reso*12,length.out = dim(b)[1]),4)
  )
  ## begin gcode
  gcode = start_gcode
  ## iterate
  for(k in seq(dim(b)[2])){ # path loop, need modulo for next loop
    if(k %% 2 == 1){
      s = seq(dim(b)[1])
    }else{
      s = seq(dim(b)[1]) %>% rev
    }
    for(j in s){
      if(b[j,k] != 0){
        gcode = c(gcode,paste0("G1 Y",coordonate$Y[j]," ; go in position")) ## X and Y are not inversed, carefull
        gcode = c(gcode,"M400 ; Wait for current moves to finish ")
        gcode = c(gcode,paste0("M700 P0 I",I," L",L," S",b[j,k]," ; Fire inkjet bits"))
      }
    }
    if(W != 0){gcode=c(gcode,paste0("G4 S",W,"; wait in seconds"))}
  }
  c(gcode,end_gcode)
}

a_to_gcode_X_fix = function(a,start_gcode,end_gcode,I=1,L=5,W=0,nozzle = 1){ ## function to use a single nozzle
  S = rep(0,12)
  for(i in seq(12)){if(i %in% as.numeric(nozzle)){S[i] = 1}};S = BinToDec(S)
  ## empty array
  inche = 25.4 # mm/inche
  dpi = 96
  reso = inche/dpi
  nozzle_Y = 1
  plate_Y=100
  Y=floor(plate_Y/reso/nozzle_Y)*nozzle_Y
  shift = (1 - nozzle)*reso
  ## get coord
  coordonate = list(
    Y = round(seq(from=reso/2,by = reso*nozzle_Y,length.out = dim(a)[1]) + shift,4)
  )
  ## begin gcode
  gcode = start_gcode
  ## iterate
  for(k in seq(dim(a)[2])){ # path loop, need modulo for next loop
    if(k %% 2 == 1){
      s = seq(dim(a)[1])
    }else{
      s = seq(dim(a)[1]) %>% rev
    }
    for(j in s){
      if(a[j,k] != 0){
        gcode = c(gcode,paste0("G1 Y",coordonate$Y[j]," ; go in position")) ## X and Y are not inversed, carefull
        gcode = c(gcode,"M400 ; Wait for current moves to finish ")
        gcode = c(gcode,paste0("M700 P0 I",I," L",L," S",S," ; Fire inkjet bits"))
      }
    }
    if(W != 0){gcode=c(gcode,paste0("G4 S",W,"; wait in seconds"))}
  }
  c(gcode,end_gcode)
}




f.read.image = function(source,height=NULL,Normalize=F,ls.format=F){
  ls <- list()
  for(i in source){
    try(data<-readTIFF(i,native=F)) # we could use the magic number instead of try here
    try(data<-readJPEG(source=i,native=F))
    try(data<-readPNG(source=i,native=F))
    if(!is.null(height)){
      data <- redim.array(data,height)
    }
    if(Normalize == T){data <- data %>% normalize}
    ls[[i]]<- data
  }
  if(ls.format == F){
    data <- abind(ls,along=2)
  }else{
    data <- ls
  }
  return(data)
}