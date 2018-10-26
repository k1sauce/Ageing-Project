load("~/R/ageing/datasets/alzheimers/females/na_fill_mvalues_female_brain_controls.r")
load("~/R/ageing/datasets/alzheimers/females/na_fill_mvalues_female_brain_diseased.r")

healthy <- t(na_fill_mvalues_female_brain_controls)
disease <- t(na_fill_mvalues_female_brain_diseased)

healthy_index <- sample(229, 0.7*229)
disease_index <- sample(70, 0.7*70)

healthy_train <- healthy[healthy_index,]
disease_train <- disease[disease_index,]

healthy_test <- healthy[-healthy_index,]
disease_test <- disease[-disease_index,]

x_train <- rbind(healthy_train,disease_train)
y_train <- data.frame(c(rep(0,160),rep(1,49)))
yx_train <- cbind(y_train,x_train)
colnames(yx_train)[1] <- "y"
setwd("~/R/ageing/datasets/alzheimers/females")
save(yx_train, file = "yx_train.r")
load("~/R/ageing/datasets/alzheimers/females/yx_train.r")

x_test <- rbind(healthy_test, disease_test)
y_test <- data.frame(c(rep(0,69),rep(1,21)))
yx_test <- cbind(y_test,x_test)
colnames(yx_test)[1] <- "y"
setwd("~/R/ageing/datasets/alzheimers/females")
save(yx_test, file = "yx_test.r")
load("~/R/ageing/datasets/alzheimers/females/yx_test.r")

library(neuralnet)
n <- colnames(yx_train)
f <- as.formula(paste("y ~", paste(n[!n %in% "y"], collapse = " + ")))
nn <- neuralnet(f,data=yx_train,hidden=c(100,10),linear.output=F, act.fct = "logistic", err.fct = "ce")
save(nn, file="nn_yx_train.r")
load("~/R/ageing/datasets/alzheimers/females/nn_yx_train.r")

delta <- as.numeric(data.frame(nn$net.result)[,1])-as.numeric(nn$response)
sum(abs(delta>0.5))


pr_nn <- compute(nn,yx_test[,2:5001])
prdf <- cbind(pr_nn$net.result,yx_test[,1])
prdf <- data.frame(prdf)
prdf$delta <- prdf$X2 - prdf$X1 
hist(prdf$delta)
sum(abs(prdf$delta)>0.5)



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

source("~/R/ageing/functions/double_mad_from_med.r")

xres <- x[DoubleMADsFromMedian(x) > 3]
probe_index <- names(xres)
save(probe_index, file="gw_probe_index.r")

yx_train_gw <- yx_train[,probe_index]
yx_train_gw <- cbind(yx_train[,1],yx_train_gw)
colnames(yx_train_gw)[1] <- "y"
setwd("~/R/ageing/datasets/alzheimers/females/")
save(yx_train_gw, file = "yx_train_gw.r")
n <- colnames(yx_train_gw)
f <- as.formula(paste("y ~", paste(n[!n %in% "y"], collapse = " + ")))
nn_gw <- neuralnet(f,data=yx_train_gw,hidden=c(100,10),linear.output=F, act.fct = "logistic", err.fct = "ce")
save(nn_gw, file="nn_yx_train_gw.r")
load("nn_yx_train_gw.r")

delta <- as.numeric(data.frame(nn_gw$net.result)[,1])-as.numeric(nn_gw$response)
sum(abs(delta)>0.5)


load("gw_probe_index.r")
load("~/R/ageing/datasets/alzheimers/females/yx_test.r")
yx_test_gw <- yx_test[,probe_index]
yx_test_gw <- cbind(yx_test[,1],yx_test_gw)
colnames(yx_test_gw)[1] <- "y"
setwd("~/R/ageing/datasets/alzheimers/females")
save(yx_test_gw, file = "yx_test_gw.r")
load("yx_test_gw.r")
pr_nn_gw <- compute(nn_gw,yx_test_gw[,2:390])
prdf <- cbind(pr_nn_gw$net.result,yx_test_gw[,1])
prdf <- data.frame(prdf)
prdf$delta <- prdf$X2 - prdf$X1 
hist(prdf$delta)
sum(abs(prdf$delta)>0.5)

prdf <- prdf[order(-prdf$X1),]
rank <- rev(seq_along(prdf$X1))
library(pROC)
roc_obj <- roc(prdf$X2, rank)
auc(roc_obj)
# Area under the curve: 0.8357488
# 69/90 = 77%
# n_disease 21
# n_control 69
# n_total 90

#TP = "has disease 1 and predict disease 1": 15
TP = sum(prdf$X2 == 1 & prdf$X1 > 0.5)

#FP = "does not have disease 0 and predict disease 1": 15
FP = sum(prdf$X2 == 0 & prdf$X1 > 0.5)

#TN = "does not have disease 0 and predict disease 0": 54
TN = sum(prdf$X2 == 0 & prdf$X1 < 0.5)

#FN = "has disease 1 and predict disease 0": 6
FN = sum(prdf$X2 == 1 & prdf$X1 < 0.5)
