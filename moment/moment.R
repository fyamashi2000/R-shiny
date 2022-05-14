#################################################################
#  Copyright (c) 2022 Fumiyoshi Yamashita. All rights reserved  #
#################################################################

log_trapezoidal <- function(x1,y1,x2,y2) {
  b<-log(y2/y1)/(x2-x1)
  p0 <- (y2-y1)/b
  p1 <- (x2*y2-x1*y1)/b-(y2-y1)/b^2
  p2 <- (x2^2*y2-x1^2*y1)/b-2*(x2*y2-x1*y1)/b^2+2*(y2-y1)/b^3
  return(c(p0,p1,p2))
}

trapezoidal <- function(x1,y1,x2,y2) {
  p0 <- (y1+y2)*(x2-x1)/2.
  p1 <- (x1*y1+x2*y2)*(x2-x1)/2.
  p2 <- (x1^2*y1+x2^2*y2)*(x2-x1)/2.
  return(c(p0,p1,p2))
}

extrapl <- function(x,y,regressRange,a,b){
  model<-lm(log(y[regressRange])~x[regressRange])
  A <- exp(coef(model)[1])
  alpha <- coef(model)[2]
  p0 <- A/alpha*(exp(alpha*b)-exp(alpha*a))
  p1 <- A/alpha*(b*exp(alpha*b)-a*exp(alpha*a))
  p1 <- p1 - A/alpha^2*(exp(alpha*b)-exp(alpha*a))
  p2 <- A/alpha*(b^2*exp(alpha*b)-a^2*exp(alpha*a))
  p2 <- p2 - 2.*A/alpha^2*(b*exp(alpha*b)-a*exp(alpha*a))
  p2 <- p2 + 2.*A/alpha^3*(exp(alpha*b)-exp(alpha*a))
  return(list(regres=c(A,alpha), moment=c(p0,p1,p2)))
}

extrapl_zero_trapezoidal <- function(x,y,regressRange,a,b){
  model<-lm(log(y[regressRange])~x[regressRange])
  A <- exp(coef(model)[1])
  alpha <- coef(model)[2]
  div <- trapezoidal(0,A,x[1],y[1])
  return(list(regres=c(A,alpha), moment=div))
}

moment <- function(x,y,n1,n0=0){
  
  ndata <- length(x)

  # ピーク以降、対数台形公式
  # tp <- which.max(y)
  # up <- mapply(trapezoidal,x[1:(tp-1)],y[1:(tp-1)],x[2:tp],y[2:tp])
  # down <- mapply(log_trapezoidal,x[tp:(ndata-1)],y[tp:(ndata-1)],x[(tp+1):ndata],y[(tp+1):ndata])
  # s <- apply(cbind(up,down),1,sum)
  # ゼロ点外挿
  # if(n0>0) {
  #   s <- s + extrapl(x, y, 1:n0, 0, x[1])
  # }
  # else {
  #   s <- s + trapezoidal(0,0,x[1],y[1])
  # }
  
  # 台形公式
  div <- mapply(trapezoidal,x[1:(ndata-1)],y[1:(ndata-1)],x[2:ndata],y[2:ndata])
  s <- apply(div,1,sum)
  # ゼロ点外挿
  if(n0>1) {
    expl0 <- extrapl_zero_trapezoidal(x, y, 1:n0, 0, x[1])
    s <- s + expl0$moment
  }
  else {
    s <- s + trapezoidal(0,0,x[1],y[1])
  }

  finite<-c(s[1], s[2]/s[1], s[3]/s[1]-(s[2]/s[1])^2)
  
  # 無限大外挿
  expl1 <- extrapl(x, y, (ndata-n1+1):ndata, x[ndata], 10^12)
  s <- s + expl1$moment
  infinite<-c(s[1], s[2]/s[1], s[3]/s[1]-(s[2]/s[1])^2)
  
  
  pdata0=NULL
  if(n0>1){
    pdata0 <- matrix(c(0,x[n0],expl0$regres[1],expl0$regres[1]*exp(expl0$regres[2]*x[n0])),2)
  }
  pdata1 <- matrix(c(x[ndata-n1+1],x[ndata],expl1$regres[1]*exp(expl1$regres[2]*x[ndata-n1+1])
                     ,expl1$regres[1]*exp(expl1$regres[2]*x[ndata])),2)
  res <- as.data.frame(rbind(finite,infinite))
  res <- cbind(c("0-tmax","0-infinity"),res)
  colnames(res) <- c("","AUC","MRT","VRT")

  return(list(pdata0=pdata0,pdata1=pdata1,moment=res))
  
}

