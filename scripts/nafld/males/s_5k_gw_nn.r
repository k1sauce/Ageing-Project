load("~/R/ageing/datasets/nafld/males/na_fill_mvalues_male_liver_controls.r")
load("~/R/ageing/datasets/nafld/males/na_fill_mvalues_male_liver_diseased.r")

healthy <- t(na_fill_mvalues_male_liver_controls)
disease <- t(na_fill_mvalues_male_liver_diseased)

healthy_index <- sample(64, 0.7*64)
disease_index <- sample(24, 0.7*24)

healthy_train <- healthy[healthy_index,]
disease_train <- disease[disease_index,]

healthy_test <- healthy[-healthy_index,]
disease_test <- disease[-disease_index,]

x_train <- rbind(healthy_train,disease_train)
y_train <- data.frame(c(rep(0,dim(healthy_train)[1]),rep(1,dim(disease_train)[1])))

yx_train <- cbind(y_train,x_train)
colnames(yx_train)[1] <- "y"
n <- colnames(yx_train)
f <- as.formula(paste("y ~", paste(n[!n %in% "y"], collapse = " + ")))
nn <- neuralnet(f,data=yx_train,hidden=c(200,100,10),linear.output=F, act.fct = "logistic", err.fct = "ce")

gw <- nn$generalized.weights[[1]]
vinputs <- apply(gw, MARGIN = 2, FUN = var, na.rm=T)
table(vinputs > 1)
summary(vinputs)
tmp <- data.frame(colnames(yx_train)[2:5001], vinputs)
colnames(tmp) <- c("Probe","G_Weight")
varGweightnn <- tmp
varGweightnn <- varGweightnn[order(-varGweightnn$G_Weight),]
x <- varGweightnn$G_Weight
names(x) <- varGweightnn$Probe
source("~/R/ageing/functions/double_mad_from_med.r")
xres <- x[DoubleMADsFromMedian(x) > 3]
probe_index_gw <- names(xres)

yx_train <- cbind(y_train,x_train[,probe_index_gw])
colnames(yx_train)[1] <- "y"
n <- colnames(yx_train)
f <- as.formula(paste("y ~", paste(n[!n %in% "y"], collapse = " + ")))
nn <- neuralnet(f,data=yx_train,hidden=c(50),linear.output=F, act.fct = "logistic", err.fct = "ce")
save(nn, file = "nn_gw.r")
load("nn_gw.r")


#########

setwd("~/R/ageing/datasets/nafld/males")
save(yx_train, file = "yx_train.r")
load("~/R/ageing/datasets/nafld/males/yx_train.r")

x_test <- rbind(healthy_test, disease_test)
y_test <- data.frame(c(rep(0,dim(healthy_test)[1]),rep(1,dim(disease_test)[1]))) # can also use extra blood data in validation
yx_test <- cbind(y_test,x_test)
colnames(yx_test)[1] <- "y"
setwd("~/R/ageing/datasets/nafld/males")
save(yx_test, file = "yx_test.r")
load("~/R/ageing/datasets/nafld/males/yx_test.r")


# validation

pr_nn <- compute(nn,yx_test[,probe_index_gw])
prdf <- cbind(pr_nn$net.result,yx_test[,1])
prdf <- data.frame(prdf)
prdf$delta <- prdf$X2 - prdf$X1 
hist(prdf$delta)
sum(abs(prdf$delta)>0.5)

save(probe_index_gw,file = "probe_index_gw.r")
load('probe_index_gw.r')

prdf <- prdf[order(-prdf$X1),]
rank <- rev(seq_along(prdf$X1))
library(pROC)
roc_obj <- roc(prdf$X2, rank)
auc(roc_obj)
# Area under the curve: 0.98125
# 26/28 = 92%
# n_disease 8
# n_control 20
# n_total 28

#TP = "has disease 1 and predict disease 1": 8
TP = sum(prdf$X2 == 1 & prdf$X1 > 0.5)

#FP = "does not have disease 0 and predict disease 1": 2
FP = sum(prdf$X2 == 0 & prdf$X1 > 0.5)

#TN = "does not have disease 0 and predict disease 0": 18
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
