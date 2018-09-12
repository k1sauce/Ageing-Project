load("~/R/ageing/datasets/rheumatoid_arthritis/males/GSE42861_ra/GSE42861_ra.r")
load("~/R/ageing/datasets/rheumatoid_arthritis/females/na_fill_mvalues_female_blood_controls.r")
load("~/R/ageing/datasets/rheumatoid_arthritis/females/na_fill_mvalues_female_blood_diseased.r")

ratmp <- data.frame(as.character(ra[[2]]), as.character(ra[[14]]))
raf <- subset(ratmp, ratmp[,2] == "gender: f")
GSE42861IDs <- as.character(raf[,1])
rm(ra)

na_fill_table <- cbind(na_fill_mvalues_female_blood_controls, na_fill_mvalues_female_blood_diseased)
gse <- na_fill_table[,GSE42861IDs]
diseaseid <- colnames(na_fill_mvalues_female_blood_diseased)
mts <- match(diseaseid, colnames(gse))
disease <- gse[,mts]
healthy <- gse[,-mts]


healthy <- t(healthy)
disease <- t(disease)

healthy_index <- sample(239, 0.7*239)
disease_index <- sample(253, 0.7*253)

healthy_train <- healthy[healthy_index,]
disease_train <- disease[disease_index,]

healthy_test <- healthy[-healthy_index,]
disease_test <- disease[-disease_index,]

x_train <- rbind(healthy_train,disease_train)
y_train <- data.frame(c(rep(0,167),rep(1,177)))
yx_train <- cbind(y_train,x_train)
colnames(yx_train)[1] <- "y"
setwd("~/R/ageing/datasets/rheumatoid_arthritis/females")
save(yx_train, file = "yx_train_single_gse.r")
load("~/R/ageing/datasets/rheumatoid_arthritis/females/yx_train_single_gse.r")

x_test <- rbind(healthy_test, disease_test)
y_test <- data.frame(c(rep(0,72),rep(1,76)))
yx_test <- cbind(y_test,x_test)
colnames(yx_test)[1] <- "y"
setwd("~/R/ageing/datasets/rheumatoid_arthritis/females")
save(yx_test, file = "yx_test_single_gse.r")
load("~/R/ageing/datasets/rheumatoid_arthritis/females/yx_test_single_gse.r")

library(neuralnet)
n <- colnames(yx_train)
f <- as.formula(paste("y ~", paste(n[!n %in% "y"], collapse = " + ")))
nn <- neuralnet(f,data=yx_train,hidden=c(200,100,10),linear.output=F, act.fct = "logistic", err.fct = "ce")
save(nn, file="nn_yx_train.r")
load("~/R/ageing/datasets/rheumatoid_arthritis/females/nn_yx_train.r")

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
save(probe_index, file="single_gse_gw_probe_index.r")

yx_train_gw <- yx_train[,probe_index]
yx_train_gw <- cbind(yx_train[,1],yx_train_gw)
colnames(yx_train_gw)[1] <- "y"
setwd("~/R/ageing/datasets/rheumatoid_arthritis/females/")
save(yx_train_gw, file = "yx_train_single_gse_gw.r")
n <- colnames(yx_train_gw)
f <- as.formula(paste("y ~", paste(n[!n %in% "y"], collapse = " + ")))
nn_gw <- neuralnet(f,data=yx_train_gw,hidden=c(200,100,10),linear.output=F, act.fct = "logistic", err.fct = "ce")
save(nn_gw, file="nn_yx_train_single_gse_gw.r")

delta <- as.numeric(data.frame(nn_gw$net.result)[,1])-as.numeric(nn_gw$response)
sum(abs(delta>0.5))


load("~/R/ageing/datasets/rheumatoid_arthritis/females/yx_test_single_gse.r")
yx_test_gw <- yx_test[,probe_index]
yx_test_gw <- cbind(yx_test[,1],yx_test_gw)
colnames(yx_test_gw)[1] <- "y"
setwd("~/R/ageing/datasets/rheumatoid_arthritis/females")
save(yx_test_gw, file = "yx_test_single_gse_gw.r")
pr_nn_gw <- compute(nn_gw,yx_test_gw[,2:391])
prdf <- cbind(pr_nn_gw$net.result,yx_test_gw[,1])
prdf <- data.frame(prdf)
prdf$delta <- prdf$X2 - prdf$X1 
hist(prdf$delta)
sum(abs(prdf$delta)>0.5)

#124/148 = 84%
