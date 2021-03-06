library(minpack.lm)
#################################################################
#  Copyright (c) 2022 Fumiyoshi Yamashita. All rights reserved  #
#################################################################
# 数式定義
func <- function(p,obs){
  # 時間変数の定義 例えば time1 -> obs[[1]]$x
  x1 <- obs[[1]]$x
  x2 <- obs[[2]]$x
  # モデル式
  y1 <- 100./p[2]*exp(-p[1]/p[2]*x1)
  y2 <- 100.*p[3]/(p[1]-p[3]*p[2])*(exp(-p[3]*x2)-exp(-p[1]/p[2]*x2))
  # モデル式の数に応じたリスト化
  return(list(y1,y2))
}
#################################################################
# 誤差計算
residual <- function(p,obs,isAbsError=TRUE){
  num <- length(obs)
  f <- func(p,obs)
  err <- c()
  for(i in 1:num){
    temp <- obs[[i]]$y - f[[i]]
    if(!isAbsError) temp <- temp/obs[[i]]$y
    err <- c(err,temp)
  }
  return(err)
}

# 非線形最小二乗法
nlm <- function(p,obs,isAbsError=TRUE){
  nls.lm(p,fn=residual,obs=obs,isAbsError=isAbsError, control=nls.lm.control(maxiter=1024,nprint=1))
}
