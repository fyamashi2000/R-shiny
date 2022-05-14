library(minpack.lm)
library(deSolve)
#################################################################
#  Copyright (c) 2022 Fumiyoshi Yamashita. All rights reserved  #
#################################################################
# 微分方程式を定義
diffEq <- function(times, state, p){
  with(as.list(c(state,p)),{
    
    dy1 <- (p[3]*y2-p[1]*y1)/p[2]
    dy2 <- -p[3]*y2
    list(c(dy1,dy2))

  })
}

# 初期条件を定義
    initial <- c( y1=0, y2=100.)
#################################################################
# 誤差計算
residual <- function(p,times,obs,isAbsError=TRUE){
  out <- lsoda(y=initial, times=times, func=diffEq, parms=p)
  num <- length(obs)
  err <- c()
  for(i in 1:num){
    temp <- out[,c(1,i+1)]
    temp <- obs[[i]]$y - temp[which(temp[,1] %in% obs[[i]]$x),2]
    if(!isAbsError) temp <- temp/obs[[i]]$y
    err <- c(err,temp)
  }
  return(err)
}

# 非線形最小二乗法
nlm <- function(p,obs,isAbsError=TRUE){
  num <- length(obs)
  times <- c(0)
  for(i in 1:num){
    times <- c(times,obs[[i]]$x)
  }
  times <- unique(sort(times))
  nls.lm(p,fn=residual,times=times, obs=obs,isAbsError=isAbsError, control=nls.lm.control(maxiter=1024,nprint=1))
}

# シミュレーション
func <-function(p,obs){
  num <- length(obs)
  times <- c(0)
  for(i in 1:num){
    times <- c(times,obs[[i]]$x)
  }
  times <- unique(sort(times))
  out <- lsoda(y=initial, times=times, func=diffEq, parms=p)
  y <- c()
  for(i in 1:num){
    temp <- out[,c(1,i+1)]
    y <- c(y, list(temp[which(temp[,1] %in% obs[[i]]$x),2]))
  }
  return(y)
}
