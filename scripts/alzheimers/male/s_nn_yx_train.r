load("~/R/ageing/datasets/rheumatoid_arthritis/males/yx_train.r")
library(neuralnet)
# train the nn on the training data
n <- colnames(yx_train)
f <- as.formula(paste("y ~", paste(n[!n %in% "y"], collapse = " + ")))
nn <- neuralnet(f,data=yx_train,hidden=c(200),linear.output=F, act.fct = "logistic", err.fct = "ce")
save(nn, file="nn_yx_train.r")

# quick check on the classification performance
delta <- as.numeric(data.frame(nn$net.result)[,1])-as.numeric(nn$response)
sum(abs(delta>0.5))


# I use the variance of the generalized weights among all samples to determine which probes have the largest effect on the outcome
gw <- nn$generalized.weights[[1]]
vinputs <- apply(gw, MARGIN = 2, FUN = var, na.rm=T)
table(vinputs > 1)
hist(vinputs)
summary(vinputs)
tmp <- data.frame(colnames(yx_train)[2:5001], vinputs)
colnames(tmp) <- c("Probe","G_Weight")
varGweightnn <- tmp
varGweightnn <- varGweightnn[order(-varGweightnn$G_Weight),]

x <- varGweightnn$G_Weight
names(x) <- varGweightnn$Probe

xres <- x[DoubleMADsFromMedian(x) > 3]
DoubleMAD <- function(x, zero.mad.action="warn"){
  # The zero.mad.action determines the action in the event of an MAD of zero.
  # Possible values: "stop", "warn", "na" and "warn and na".
  x         <- x[!is.na(x)]
  m         <- median(x)
  abs.dev   <- abs(x - m)
  left.mad  <- median(abs.dev[x<=m])
  right.mad <- median(abs.dev[x>=m])
  if (left.mad == 0 || right.mad == 0){
    if (zero.mad.action == "stop") stop("MAD is 0")
    if (zero.mad.action %in% c("warn", "warn and na")) warning("MAD is 0")
    if (zero.mad.action %in% c(  "na", "warn and na")){
      if (left.mad  == 0) left.mad  <- NA
      if (right.mad == 0) right.mad <- NA
    }
  }
  return(c(left.mad, right.mad))
}


DoubleMADsFromMedian <- function(x, zero.mad.action="warn"){
  # The zero.mad.action determines the action in the event of an MAD of zero.
  # Possible values: "stop", "warn", "na" and "warn and na".
  two.sided.mad <- DoubleMAD(x, zero.mad.action)
  m <- median(x, na.rm=TRUE)
  x.mad <- rep(two.sided.mad[1], length(x))
  x.mad[x > m] <- two.sided.mad[2]
  mad.distance <- abs(x - m) / x.mad
  mad.distance[x==m] <- 0
  return(mad.distance)
}

probe_index <- names(xres)

#train a second nn with the most influential probes
yx_train_gw <- yx_train[,probe_index]
yx_train_gw <- cbind(yx_train[,1],yx_train_gw)
colnames(yx_train_gw)[1] <- "y"
setwd("~/R/ageing/datasets/rheumatoid_arthritis/males")
save(yx_train_gw, file = "yx_train_gw.r")
n <- colnames(yx_train_gw)
f <- as.formula(paste("y ~", paste(n[!n %in% "y"], collapse = " + ")))
nn_gw <- neuralnet(f,data=yx_train_gw,hidden=c(200),linear.output=F, act.fct = "logistic", err.fct = "ce")
save(nn_gw, file="nn_yx_train_gw.r")



#Now evaluate the performance on the validation data set, the neural network has never been trained on this data!
load("~/R/ageing/datasets/rheumatoid_arthritis/males/yx_test.r")
yx_test_gw <- yx_test[,probe_index]
yx_test_gw <- cbind(yx_test[,1],yx_test_gw)
colnames(yx_test_gw)[1] <- "y"
setwd("~/R/ageing/datasets/rheumatoid_arthritis/males")
save(yx_test_gw, file = "yx_test_gw.r")
pr_nn_gw <- compute(nn_gw,yx_test_gw[,2:468])
prdf <- cbind(pr_nn_gw$net.result,yx_test_gw[,1])
prdf <- data.frame(prdf)
prdf$delta <- prdf$X2 - prdf$X1 
hist(prdf$delta)
sum(abs(prdf$delta)>0.5)


# value is over the 10 threshold for useful diagnostic tests
sum(prdf$delta>0.5)
#FP = 9
sum(prdf$delta < -0.5)
#FN = 13
sum(prdf$X1 + prdf$X2 > 1.5)
#TP = 18
sum(prdf$X1 + prdf$X2 < 0.5)
#TN = 788

#18/9 = 2
#131/788 = 0.1662

#2/ 0.1662 = 12