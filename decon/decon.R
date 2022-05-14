#################################################################
#  Copyright (c) 2022 Fumiyoshi Yamashita. All rights reserved  #
#################################################################

library(pracma)

deconvolution <- function(x_iv,y_iv,x_po,y_po){
  
  #removal of non-numeric data
  x_iv<-x_iv[is.na(x_iv)==F]
  y_iv<-y_iv[is.na(y_iv)==F]
  x_po<-x_po[is.na(x_po)==F]
  y_po<-y_po[is.na(y_po)==F]
 
  #extrapolation to t_zero
  #y0_iv <- 0
  y0_iv <- y_iv[1]*(y_iv[2]/y_iv[1])^(-x_iv[1]/(x_iv[2]-x_iv[1]))
  x_iv <- c(0,x_iv)
  y_iv <- c(y0_iv,y_iv)
  
  #definition for calculation of AUC at any intervals
  g <- splinefun(x_iv,y_iv)
  auc <- function(t1,t2) integrate(g,t1,t2)$value
  
  #calculation of AUC matrix and absorption rate
  x_po <- c(0,x_po)
  m <- matrix(rep(x_po,length(x_po)),length(x_po))
  m<-m-t(m)
  m[upper.tri(m)] <- 0
  m_auc <- matrix(mapply(auc,m[-1,-1],m[-1,-ncol(m)]),ncol(m)-1)
  rate <- lsqnonneg(m_auc,y_po) #non-negative solution in linear least squares 
  
  #output of cummulative input function values
  res <- cbind(time=x_po, absorption=c(0,cumsum(rate$x*diff(x_po))))
  return(res)
}
