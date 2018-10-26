load("~/R/ageing/datasets/nafld/females/na_fill_mvalues_female_liver_controls.r")
load("~/R/ageing/datasets/nafld/females/na_fill_mvalues_female_liver_diseased.r")

healthy <- t(na_fill_mvalues_female_liver_controls)
disease <- t(na_fill_mvalues_female_liver_diseased)

healthy_index <- sample(75, 0.9*75)
disease_index <- sample(26, 0.9*26)

healthy_train <- healthy[healthy_index,]
disease_train <- disease[disease_index,]

healthy_test <- healthy[-healthy_index,]
disease_test <- disease[-disease_index,]

x_train <- rbind(healthy_train,disease_train)
y_train <- data.frame(c(rep(0,dim(healthy_train)[1]),rep(1,dim(disease_train)[1])))

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

# cocatenate probe indexes

probe_index <- c(probe_index1to1000,probe_index1001to2000,probe_index2001to3000,probe_index3001to4000,probe_index4001to5000)
save(probe_index, file = "probe_index.r")
load("probe_index.r")

yx_train <- cbind(y_train,x_train[,probe_index])
colnames(yx_train)[1] <- "y"
n <- colnames(yx_train)
f <- as.formula(paste("y ~", paste(n[!n %in% "y"], collapse = " + ")))
nn <- neuralnet(f,data=yx_train,hidden=c(100),linear.output=F, act.fct = "logistic", err.fct = "ce")

gw <- nn$generalized.weights[[1]]
vinputs <- apply(gw, MARGIN = 2, FUN = var, na.rm=T)
table(vinputs > 1)
summary(vinputs)
tmp <- data.frame(colnames(yx_train)[2:388], vinputs)
colnames(tmp) <- c("Probe","G_Weight")
varGweightnn <- tmp
varGweightnn <- varGweightnn[order(-varGweightnn$G_Weight),]
x <- varGweightnn$G_Weight
names(x) <- varGweightnn$Probe
source("~/R/ageing/functions/double_mad_from_med.r")
xres <- x[DoubleMADsFromMedian(x) > 1]
probe_index_gw <- names(xres)

yx_train <- cbind(y_train,x_train[,probe_index])
colnames(yx_train)[1] <- "y"
n <- colnames(yx_train)
f <- as.formula(paste("y ~", paste(n[!n %in% "y"], collapse = " + ")))
nn <- neuralnet(f,data=yx_train,hidden=c(100),linear.output=F, act.fct = "logistic", err.fct = "ce")
save(nn, file = "nn_pi.r")
load("nn_pi.r")
#########

setwd("~/R/ageing/datasets/nafld/females")
save(yx_train, file = "yx_train.r")
load("~/R/ageing/datasets/nafld/females/yx_train.r")

x_test <- rbind(healthy_test, disease_test)
y_test <- data.frame(c(rep(0,dim(healthy_test)[1]),rep(1,dim(disease_test)[1]))) # can also use extra blood data in validation
yx_test <- cbind(y_test,x_test)
colnames(yx_test)[1] <- "y"
setwd("~/R/ageing/datasets/nafld/females")
save(yx_test, file = "yx_test.r")
load("~/R/ageing/datasets/nafld/females/yx_test.r")


# validation

pr_nn <- compute(nn,yx_test[,probe_index])
prdf <- cbind(pr_nn$net.result,yx_test[,1])
prdf <- data.frame(prdf)
prdf$delta <- prdf$X2 - prdf$X1 
hist(prdf$delta)
sum(abs(prdf$delta)>0.5)

prdf <- prdf[order(-prdf$X1),]
rank <- rev(seq_along(prdf$X1))
library(pROC)
roc_obj <- roc(prdf$X2, rank)
auc(roc_obj)
# Area under the curve: 1


# 31/31 = 100%
# n_disease 8
# n_control 23
# n_total 31

#TP = "has disease 1 and predict disease 1": 23
TP = sum(prdf$X2 == 1 & prdf$X1 > 0.5)

#FP = "does not have disease 0 and predict disease 1": 0
FP = sum(prdf$X2 == 0 & prdf$X1 > 0.5)

#TN = "does not have disease 0 and predict disease 0": 8
TN = sum(prdf$X2 == 0 & prdf$X1 < 0.5)

#FN = "has disease 1 and predict disease 0": 0
FN = sum(prdf$X2 == 1 & prdf$X1 < 0.5)







#####################################
#####################################
#####################################
#The following code was used for experimentation 
#only.
#####################################
#####################################
#####################################
#Tensor Flow#
#####################################

library(keras)
library(tensorflow)

# Data Preparation ---------------------------------------------------

batch_size <- 16
epochs <- 30

x_train <- as.matrix(yx_train[,2:5001])
y_train <- to_categorical(as.matrix(yx_train[,1]),2)
x_test <- as.matrix(yx_test[,2:5001])
y_test <- to_categorical(as.matrix(yx_test[,1]),2)

# Define Model --------------------------------------------------------------

model <- keras_model_sequential()
model %>% 
  layer_dense(units = 500, activation = 'relu', input_shape = c(5000)) %>% 
  layer_dropout(rate = 0.5)
  layer_dense(units = 2, activation = 'softmax')

summary(model)

model %>% compile(
  loss = 'categorical_crossentropy',
  optimizer = "adam",
  metrics = 'acc'
)

history <- model %>% fit(
  x_train, y_train,
  batch_size = batch_size,
  epochs = epochs,
  validation_split = 0
)

plot(history)




##############################################
#elastic net glmnet
##############################################


train_glm = cv.glmnet(x = as.matrix(yx_train[,2:5001]), y = as.matrix(yx_train[,1]), family = "binomial", type.measure = "auc", nfolds = 3, lambda = seq(0.001,0.1,by = 0.001),
                         standardize=FALSE )
plot(train_glm)

train_glm$lambda.min

pr_glm <- predict(train_glm, newx = as.matrix(yx_test[,2:5001]), type = "class", s = 0.041)

prdf <- cbind(as.numeric(pr_glm), as.numeric(as.character(yx_test[,1])))
colnames(prdf) <- c("yhat","y")
prdf <- data.frame(prdf)
prdf$delta <- prdf$y - prdf$yhat 
hist(prdf$delta)
sum(abs(prdf$delta) > 0.5)
sum(prdf$delta > 0.5)
sum(prdf$delta < -0.5)

tmp <- coef(train_glm, s = train_glm$lambda.min)
tmp <- as.matrix(tmp)

prediction_probes <- tmp[tmp>0,]


# caret

cv_5 = trainControl(method = "cv", number = 5)

yx_train$y <- as.factor(yx_train$y)
yx_test$y <- as.factor(yx_test$y)


def_elnet <- train(y ~ ., data = yx_train,
                   method = "glmnet",
                   trControl = cv_5,
                   tuneLength = 10
)

get_best_result = function(caret_fit) {
  best = which(rownames(caret_fit$results) == rownames(caret_fit$bestTune))
  best_result = caret_fit$results[best, ]
  rownames(best_result) = NULL
  best_result
}

calc_acc = function(actual, predicted) {
  mean(actual == predicted)
}

calc_acc(actual = yx_test$y,
         predicted = predict(def_elnet, newdata = yx_test))
#93% accuracy
