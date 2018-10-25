load("~/R/ageing/datasets/rheumatoid_arthritis/males/GSE42861_ra/GSE42861_ra.r")
load("~/R/ageing/datasets/rheumatoid_arthritis/females/na_fill_mvalues_female_blood_controls.r")
load("~/R/ageing/datasets/rheumatoid_arthritis/females/na_fill_mvalues_female_blood_diseased.r")

ratmp <- data.frame(as.character(ra[[2]]), as.character(ra[[14]]))
raf <- subset(ratmp, ratmp[,2] == "gender: f")
GSE42861IDs <- as.character(raf[,1])
rm(ra)

##

na_fill_table <- cbind(na_fill_mvalues_female_blood_controls, na_fill_mvalues_female_blood_diseased)
gse <- na_fill_table[,GSE42861IDs]
diseaseid <- colnames(na_fill_mvalues_female_blood_diseased)
mts <- match(diseaseid, colnames(gse))

disease <- gse[,mts]
healthy <- gse[,-mts]

####


healthy <- t(healthy)
disease <- t(disease)

healthy_index <- sample(239, 0.7*239)
disease_index <- sample(253, 0.7*253)

healthy_train <- healthy[healthy_index,]
disease_train <- disease[disease_index,]

healthy_test <- healthy[-healthy_index,]
disease_test <- disease[-disease_index,]

x_train <- rbind(healthy_train,disease_train)
y_train <- data.frame(c(rep(0,dim(healthy_train)[1]),rep(1,dim(disease_train)[1])))

###########################
############ train 1000 features at a time
yx_train <- cbind(y_train,x_train[,1:1000])
colnames(yx_train)[1] <- "y"
n <- colnames(yx_train)
f <- as.formula(paste("y ~", paste(n[!n %in% "y"], collapse = " + ")))
nn <- neuralnet(f,data=yx_train,hidden=c(200,100,10),linear.output=F, act.fct = "logistic", err.fct = "ce")

gw <- nn$generalized.weights[[1]]
vinputs <- apply(gw, MARGIN = 2, FUN = var, na.rm=T)
table(vinputs > 1)
summary(vinputs)
tmp <- data.frame(colnames(yx_train)[2:1001], vinputs)
colnames(tmp) <- c("Probe","G_Weight")
varGweightnn <- tmp
varGweightnn <- varGweightnn[order(-varGweightnn$G_Weight),]
x <- varGweightnn$G_Weight
names(x) <- varGweightnn$Probe
source("~/R/ageing/functions/double_mad_from_med.r")
xres <- x[DoubleMADsFromMedian(x) > 3]
probe_index1to1000 <- names(xres)
save(probe_index1to1000, file = "probe_index1to1000.r")

#1001 2000
yx_train <- cbind(y_train,x_train[,1001:2000])
colnames(yx_train)[1] <- "y"
n <- colnames(yx_train)
f <- as.formula(paste("y ~", paste(n[!n %in% "y"], collapse = " + ")))
nn <- neuralnet(f,data=yx_train,hidden=c(200,100,10),linear.output=F, act.fct = "logistic", err.fct = "ce")

gw <- nn$generalized.weights[[1]]
vinputs <- apply(gw, MARGIN = 2, FUN = var, na.rm=T)
table(vinputs > 1)
summary(vinputs)
tmp <- data.frame(colnames(yx_train)[2:1001], vinputs)
colnames(tmp) <- c("Probe","G_Weight")
varGweightnn <- tmp
varGweightnn <- varGweightnn[order(-varGweightnn$G_Weight),]
x <- varGweightnn$G_Weight
names(x) <- varGweightnn$Probe
source("~/R/ageing/functions/double_mad_from_med.r")
xres <- x[DoubleMADsFromMedian(x) > 3]
probe_index1001to2000 <- names(xres)
save(probe_index1001to2000, file = "probe_index1001to2000.r")
# 2001 3000
yx_train <- cbind(y_train,x_train[,2001:3000])
colnames(yx_train)[1] <- "y"
n <- colnames(yx_train)
f <- as.formula(paste("y ~", paste(n[!n %in% "y"], collapse = " + ")))
nn <- neuralnet(f,data=yx_train,hidden=c(200,100,10),linear.output=F, act.fct = "logistic", err.fct = "ce")

gw <- nn$generalized.weights[[1]]
vinputs <- apply(gw, MARGIN = 2, FUN = var, na.rm=T)
table(vinputs > 1)
summary(vinputs)
tmp <- data.frame(colnames(yx_train)[2:1001], vinputs)
colnames(tmp) <- c("Probe","G_Weight")
varGweightnn <- tmp
varGweightnn <- varGweightnn[order(-varGweightnn$G_Weight),]
x <- varGweightnn$G_Weight
names(x) <- varGweightnn$Probe
source("~/R/ageing/functions/double_mad_from_med.r")
xres <- x[DoubleMADsFromMedian(x) > 3]
probe_index2001to3000 <- names(xres)
save(probe_index2001to3000, file = "probe_index2001to3000.r")
#3001 4000
yx_train <- cbind(y_train,x_train[,3001:4000])
colnames(yx_train)[1] <- "y"
n <- colnames(yx_train)
f <- as.formula(paste("y ~", paste(n[!n %in% "y"], collapse = " + ")))
nn <- neuralnet(f,data=yx_train,hidden=c(200,100,10),linear.output=F, act.fct = "logistic", err.fct = "ce")

gw <- nn$generalized.weights[[1]]
vinputs <- apply(gw, MARGIN = 2, FUN = var, na.rm=T)
table(vinputs > 1)
summary(vinputs)
tmp <- data.frame(colnames(yx_train)[2:1001], vinputs)
colnames(tmp) <- c("Probe","G_Weight")
varGweightnn <- tmp
varGweightnn <- varGweightnn[order(-varGweightnn$G_Weight),]
x <- varGweightnn$G_Weight
names(x) <- varGweightnn$Probe
source("~/R/ageing/functions/double_mad_from_med.r")
xres <- x[DoubleMADsFromMedian(x) > 3]
probe_index3001to4000 <- names(xres)
save(probe_index3001to4000, file = "probe_index3001to4000.r")
#4001 5000
yx_train <- cbind(y_train,x_train[,4001:5000])
colnames(yx_train)[1] <- "y"
n <- colnames(yx_train)
f <- as.formula(paste("y ~", paste(n[!n %in% "y"], collapse = " + ")))
nn <- neuralnet(f,data=yx_train,hidden=c(200,100,10),linear.output=F, act.fct = "logistic", err.fct = "ce")

gw <- nn$generalized.weights[[1]]
vinputs <- apply(gw, MARGIN = 2, FUN = var, na.rm=T)
table(vinputs > 1)
summary(vinputs)
tmp <- data.frame(colnames(yx_train)[2:1001], vinputs)
colnames(tmp) <- c("Probe","G_Weight")
varGweightnn <- tmp
varGweightnn <- varGweightnn[order(-varGweightnn$G_Weight),]
x <- varGweightnn$G_Weight
names(x) <- varGweightnn$Probe
source("~/R/ageing/functions/double_mad_from_med.r")
xres <- x[DoubleMADsFromMedian(x) > 3]
probe_index4001to5000 <- names(xres)
save(probe_index4001to5000, file = "probe_index4001to5000.r")
#
probe_index <- c(probe_index1to1000,probe_index1001to2000,probe_index2001to3000,probe_index3001to4000,probe_index4001to5000)
save(probe_index, file = "probe_index.r")
#
yx_train <- cbind(y_train,x_train[,probe_index])
colnames(yx_train)[1] <- "y"
n <- colnames(yx_train)
f <- as.formula(paste("y ~", paste(n[!n %in% "y"], collapse = " + ")))
nn <- neuralnet(f,data=yx_train,hidden=c(100),linear.output=F, act.fct = "logistic", err.fct = "ce")

gw <- nn$generalized.weights[[1]]
vinputs <- apply(gw, MARGIN = 2, FUN = var, na.rm=T)
table(vinputs > 1)
summary(vinputs)
tmp <- data.frame(colnames(yx_train)[2:269], vinputs)
colnames(tmp) <- c("Probe","G_Weight")
varGweightnn <- tmp
varGweightnn <- varGweightnn[order(-varGweightnn$G_Weight),]
x <- varGweightnn$G_Weight
names(x) <- varGweightnn$Probe
xres <- x
probe_index_gw <- names(xres)

yx_train <- cbind(y_train,x_train[,probe_index])
colnames(yx_train)[1] <- "y"
n <- colnames(yx_train)
f <- as.formula(paste("y ~", paste(n[!n %in% "y"], collapse = " + ")))
nn <- neuralnet(f,data=yx_train,hidden=c(200,100,10),linear.output=F, act.fct = "logistic", err.fct = "ce")
save(nn, file = "nn_gw.r")

#########

setwd("~/R/ageing/datasets/rheumatoid_arthritis/females")
save(yx_train, file = "yx_train.r")
load("~/R/ageing/datasets/rheumatoid_arthritis/females/yx_train.r")

x_test <- rbind(healthy_test, disease_test)
y_test <- data.frame(c(rep(0,dim(healthy_test)[1]),rep(1,dim(disease_test)[1]))) # can also use extra blood data in validation
yx_test <- cbind(y_test,x_test)
colnames(yx_test)[1] <- "y"
setwd("~/R/ageing/datasets/rheumatoid_arthritis/females")
save(yx_test, file = "yx_test.r")
load("~/R/ageing/datasets/rheumatoid_arthritis/females/yx_test.r")


# validation

pr_nn <- compute(nn,yx_test[,probe_index])
prdf <- cbind(pr_nn$net.result,yx_test[,1])
prdf <- data.frame(prdf)
prdf$delta <- prdf$X2 - prdf$X1 
hist(prdf$delta)
sum(abs(prdf$delta)>0.5)


# 105/148= 71%
# n_disease 56
# n_control 72
# n_total 148

#TP = "has disease 1 and predict disease 1": 65
TP = sum(prdf$X2 == 1 & prdf$X1 > 0.5)

#FP = "does not have disease 0 and predict disease 1": 32
FP = sum(prdf$X2 == 0 & prdf$X1 > 0.5)

#TN = "does not have disease 0 and predict disease 0": 40
TN = sum(prdf$X2 == 0 & prdf$X1 < 0.5)

#FN = "has disease 1 and predict disease 0": 11
FN = sum(prdf$X2 == 1 & prdf$X1 < 0.5)
