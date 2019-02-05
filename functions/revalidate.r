# to use this function set probe_ptp to the probe of interest and also need to set wd and load yx_train and yx_test

revalidate <- function(){
  library(neuralnet)
  #train the model and score
  yt <- yx_train$y
  xt <- yx_train[,probe_ptp]
  yxt <- cbind(yt,xt)
  colnames(yxt) <- c("y",paste0(probe_ptp))
  
  n <- colnames(yxt)
  f <- as.formula(paste("y ~", paste(n[!n %in% "y"], collapse = " + ")))
  nn <- neuralnet(f,data=yxt,hidden=c(100),linear.output=F, act.fct = "logistic", err.fct = "ce")
  
  yhat <- as.numeric(nn$net.result[[1]][,1])
  y <- as.numeric(nn$response)
  sum(abs(y - yhat)>0.5)
  
  #validation
  yv <- yx_test$y
  xv <- yx_test[,probe_ptp]
  yxv <- cbind(yv,xv)
  colnames(yxv) <- c("y",paste0(probe_ptp))
  
  pr_nn <- compute(nn,yxv[,2])
  
  yhat <- pr_nn$net.result[,1]
  y <- as.numeric(yxv[,1])
  wrong <- sum(abs(y - yhat)>0.5)
  acc <- 1 - wrong/dim(yxv)[1]
  return(acc)
}