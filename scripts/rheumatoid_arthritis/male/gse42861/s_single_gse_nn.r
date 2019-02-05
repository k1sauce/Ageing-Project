load("~/R/ageing/datasets/rheumatoid_arthritis/males/GSE42861_ra/GSE42861_ra.r")
load("~/R/ageing/datasets/rheumatoid_arthritis/males/na_fill_mvalues_male_blood_controls.r")
load("~/R/ageing/datasets/rheumatoid_arthritis/males/na_fill_mvalues_male_blood_diseased.r")

ratmp <- data.frame(as.character(ra[[2]]), as.character(ra[[14]]))
ram <- subset(ratmp, ratmp[,2] == "gender: m")
GSE42861IDs <- as.character(ram[,1])
rm(ra)

na_fill_table <- cbind(na_fill_mvalues_male_blood_controls, na_fill_mvalues_male_blood_diseased)
gse <- na_fill_table[,GSE42861IDs]
diseaseid <- colnames(na_fill_mvalues_male_blood_diseased)
mts <- match(diseaseid, colnames(gse))
disease <- gse[,mts]
healthy <- gse[,-mts]


healthy <- t(healthy)
disease <- t(disease)

healthy_index <- sample(96, 0.7*96)
disease_index <- sample(101, 0.7*101)

healthy_train <- healthy[healthy_index,]
disease_train <- disease[disease_index,]

healthy_test <- healthy[-healthy_index,]
disease_test <- disease[-disease_index,]

x_train <- rbind(healthy_train,disease_train)
y_train <- data.frame(c(rep(0,67),rep(1,70)))
yx_train <- cbind(y_train,x_train)
colnames(yx_train)[1] <- "y"
setwd("~/R/ageing/datasets/rheumatoid_arthritis/males/gse42861_ra")
save(yx_train, file = "yx_train.r")
load("~/R/ageing/datasets/rheumatoid_arthritis/males/gse42861_ra/yx_train.r")

x_test <- rbind(healthy_test, disease_test)
y_test <- data.frame(c(rep(0,29),rep(1,31)))
yx_test <- cbind(y_test,x_test)
colnames(yx_test)[1] <- "y"
setwd("~/R/ageing/datasets/rheumatoid_arthritis/males/gse42861_ra")
save(yx_test, file = "yx_test.r")
load("~/R/ageing/datasets/rheumatoid_arthritis/males/gse42861_ra/yx_test.r")

n <- colnames(yx_train)
f <- as.formula(paste("y ~", paste(n[!n %in% "y"], collapse = " + ")))
nn <- neuralnet(f,data=yx_train,hidden=c(200,100,10),linear.output=F, act.fct = "logistic", err.fct = "ce")
save(nn, file="nn_yx_train_2.r")
load("~/R/ageing/datasets/rheumatoid_arthritis/males/gse42861_ra/nn_yx_train.r")

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

yx_train_gw <- yx_train[,probe_index]
yx_train_gw <- cbind(yx_train[,1],yx_train_gw)
colnames(yx_train_gw)[1] <- "y"
setwd("~/R/ageing/datasets/rheumatoid_arthritis/males/GSE42861_ra")
save(yx_train_gw, file = "yx_train_gw.r")
n <- colnames(yx_train_gw)
f <- as.formula(paste("y ~", paste(n[!n %in% "y"], collapse = " + ")))
nn_gw <- neuralnet(f,data=yx_train_gw,hidden=c(200,100,10),linear.output=F, act.fct = "logistic", err.fct = "ce")
save(nn_gw, file="nn_yx_train_gw.r")
load("nn_yx_train_gw.r")

delta <- as.numeric(data.frame(nn_gw$net.result)[,1])-as.numeric(nn_gw$response)
sum(abs(delta>0.5))
prdf <- cbind(nn_gw$net.result[[1]],nn_gw$response)
prdf <- data.frame(prdf)
prdf$delta <- prdf$y - prdf$V1
hist(prdf$delta)
sum(abs(prdf$delta) > 0.5)


load("~/R/ageing/datasets/rheumatoid_arthritis/males/GSE42861_ra/yx_test.r")
yx_test_gw <- yx_test[,probe_index]
yx_test_gw <- cbind(yx_test[,1],yx_test_gw)
colnames(yx_test_gw)[1] <- "y"
setwd("~/R/ageing/datasets/rheumatoid_arthritis/males/GSE42861_ra")
save(yx_test_gw, file = "yx_test_gw.r")
load("yx_test_gw.r")
pr_nn_gw <- compute(nn_gw,yx_test_gw[,2:431])
prdf <- cbind(pr_nn_gw$net.result,yx_test_gw[,1])
prdf <- data.frame(prdf)
prdf$delta <- prdf$X2 - prdf$X1 
hist(prdf$delta)
sum(abs(prdf$delta)>0.5)

save(probe_index, file = "single_gse_gw_probe_index_male.r")
load("single_gse_gw_probe_index_male.r")

prdf <- prdf[order(-prdf$X1),]
rank <- rev(seq_along(prdf$X1))
library(pROC)
roc_obj <- roc(prdf$X2, rank)
auc(roc_obj)

#Area under the curve: 0.7252503

#43/60 = 70%
# n_disease 31
# n_control 29
# n_total 60

#TP = "has disease 1 and predict disease 1": 20
TP = sum(prdf$X2 == 1 & prdf$X1 > 0.5) 

#FP = "does not have disease 0 and predict disease 1": 7
FP = sum(prdf$X2 == 0 & prdf$X1 > 0.5)

#TN = "does not have disease 0 and predict disease 0": 22
TN = sum(prdf$X2 == 0 & prdf$X1 < 0.5)

#FN = "has disease 1 and predict disease 0": 11
FN = sum(prdf$X2 == 1 & prdf$X1 < 0.5)



#tensor flow
library(keras)
library(tensorflow)

# Data Preparation ---------------------------------------------------

x_train <- as.matrix(yx_train_gw[,2:431])
y_train <- as.matrix(yx_train[,1])
x_test <- as.matrix(yx_test[,2:431])
y_test <- as.matrix(yx_test[,1])

# Define Model --------------------------------------------------------------

model <- keras_model_sequential()
model %>% 
  
  layer_dense(units = 430, activation = 'sigmoid', input_shape = c(430)) %>% 
  layer_dense(units = 200, activation = 'sigmoid') %>% 
  layer_dense(units = 100, activation = 'sigmoid') %>% 
  layer_dense(units = 10, activation = 'sigmoid') %>% 
  layer_dense(units = 1, activation = 'sigmoid')

summary(model)

model %>% compile(
  loss = 'binary_crossentropy',
  optimizer = "rmsprop",
  metrics = c('accuracy')
)
batch_size <- 430 
epochs <- 500
# Fit model to data
history <- model %>% fit(
  x_train, y_train,
  batch_size = batch_size,
  shuffle = T,
  epochs = epochs,
  validation_data = list(x_test,y_test))

plot(history)

score <- model %>% evaluate(
  x_test, y_test,
  verbose = 0
)

# Output metrics
cat('Test loss:', score[[1]], '\n')
cat('Test accuracy:', score[[2]], '\n')





###################################################################
install.packages("randomForest")
library(randomForest)
ram.rf=randomForest(y ~ . , data = yxt, mtry = 70, ntree = 500, importance = T)

pr.rf <- predict(ram.rf, yx_test)
prdf <- cbind(pr.rf, yx_test$y)
prdf <- data.frame(prdf)
prdf$delta <- prdf$pr.rf - prdf$V2 
hist(prdf$delta)
sum(abs(prdf$delta) > 0.5)
sum(prdf$delta > 0.5)
sum(prdf$delta < -0.5)

#elastic net glmnet

ra_train_glm = cv.glmnet(x = as.matrix(yxt[,2]), y = as.matrix(yxt[,1]), family = "binomial", type.measure = "auc", nfolds = 5, lambda = seq(0.001,0.1,by = 0.001),
                         standardize=FALSE )
plot(ra_train_glm)

ra_train_glm$lambda.min

pr_glm <- predict(ra_train_glm, newx = as.matrix(yx_test_gw[,2:431]), type = "class", s = ra_train_glm$lambda.min)

prdf <- cbind(as.numeric(pr_glm), as.numeric(as.character(yx_test_gw[,1])))
colnames(prdf) <- c("yhat","y")
prdf <- data.frame(prdf)
prdf$delta <- prdf$y - prdf$yhat 
hist(prdf$delta)
sum(abs(prdf$delta) > 0.5)
sum(prdf$delta > 0.5)
sum(prdf$delta < -0.5)

tmp <- coef(ra_train_glm, s = ra_train_glm$lambda.min)
tmp <- as.matrix(tmp)

ra_prediction_probes_males <- tmp[tmp>0,]
save(ra_prediction_probes_males, file = "~/R/ageing/datasets/rheumatoid_arthritis/males/GSE42861_ra/ra_prediction_probes_males.r")
load("~/R/ageing/datasets/rheumatoid_arthritis/males/GSE42861_ra/ra_prediction_probes_males.r")


# caret

cv_5 = trainControl(method = "cv", number = 5)

yxt <- as.data.frame(yxt)
yxt$y <- as.factor(yxt$y)
yxv <- as.data.frame(yxv)
yxv$y <- as.factor(yxv$y)



def_elnet <- train(y ~ ., data = as.matrix(yxt),
  method = "glmnet",
  trControl = cv_5,
  tuneLength = 10
)

get_best_result = function(caret_fit) {
  best = which(rownames(caret_fit$results) == rownames(caret_fit$bestTune))
  best_result = caret_fit$results[best, ]
  rownames(best_result) = NULL
  return(best_result)
}

#75% acc

calc_acc = function(actual, predicted) {
  mean(actual == predicted)
}

calc_acc(actual = yxv$y,
         predicted = predict(def_elnet, newdata = as.matrix(yxv)))
#70% accuracy


