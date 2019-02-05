#set the probe
probe_ptp <- c("cg01100465","cg10542336","cg17658976")
#set the correct dir
setwd("~/R/ageing/datasets/rheumatoid_arthritis/males/GSE42861_ra")
#load the data
load("yx_train.r")
load("yx_test.r")

yt <- yx_train$y
xt <- yx_train[,probe_ptp]
yxt <- cbind(yt,xt)
colnames(yxt) <- c("y",paste0(probe_ptp))

#validation data
yv <- yx_test$y
xv <- yx_test[,probe_ptp]
yxv <- cbind(yv,xv)
colnames(yxv) <- c("y",paste0(probe_ptp))

s <- sample(1:60,40)

ayxt <- rbind(yxt,yxv[s,])
ayxv <- yxv[-s,]

library(keras)
library(tensorflow)

# Data Preparation ---------------------------------------------------

batch_size <- 16
epochs <- 3500

x_train <- as.matrix(ayxt[,2:dim(ayxt)[2]])
y_train <- as.matrix(ayxt[,1])
x_test <- as.matrix(ayxv[,2:dim(ayxv)[2]])
y_test <- as.matrix(ayxv[,1])

model <- keras_model_sequential()
model %>% 
  layer_dense(units = 100, activation = 'relu', input_shape = c(dim(yxt)[2]-1)) %>% 
  layer_dense(units = 400, activation = 'relu') %>% 
  layer_dense(units = 400, activation = 'relu') %>%
  layer_dense(units = 400, activation = 'relu') %>% 
  layer_dense(units = 400, activation = 'relu') %>% 
  layer_dense(units = 400, activation = 'relu') %>% 
  layer_dense(units = 100, activation = 'relu') %>%
  layer_dense(units = 100, activation = 'relu') %>% 
  layer_dense(units = 100, activation = 'relu') %>% 
  layer_dense(units = 10, activation = 'relu') %>% 
  layer_dense(units = 3, activation = 'relu') %>%
  layer_dense(units = 1, activation = 'sigmoid')

summary(model)

model %>% compile(
  loss = 'binary_crossentropy',
  optimizer = "rmsprop",
  metrics = "acc"
)
history <- model %>% fit(
  x_train, y_train,
  batch_size = batch_size,
  epochs = epochs,
  validation_data = list(x_test,y_test)
)

# run the revalidation
source("~/R/ageing/functions/tf_revalidate.r")
revalidate()
# 0.4833 accuracy

#predict age with the marker
load("~/R/ageing/datasets/rheumatoid_arthritis/males/age_yx_train_controls.r")
load("~/R/ageing/datasets/rheumatoid_arthritis/males/age_yx_test_controls.r")

age_yx_train_controls <- t(age_yx_train_controls)
age_yx_test_controls <- t(age_yx_test_controls)

x_train <- as.matrix(age_yx_train_controls[,probe_ptp])
y_train <- as.matrix(age_yx_train_controls[,"age"])
x_test <- as.matrix(age_yx_test_controls[,probe_ptp])
y_test <- as.matrix(age_yx_test_controls[,"age"])

library(tensorflow)
library(keras)
model <- keras_model_sequential()
model %>% 
  
  layer_dense(units = 100, activation = 'relu', input_shape = c(1)) %>% 
  layer_dense(units = 100, activation = 'relu') %>% 
  layer_dense(units = 100, activation = 'relu') %>% 
  layer_dense(units = 100, activation = 'relu') %>% 
  layer_dense(units = 100, activation = 'relu') %>% 
  layer_dense(units = 10, activation = 'relu') %>% 
  layer_dense(units = 1)

summary(model)

model %>% compile(
  loss = 'mse',
  optimizer = "adam",
  metrics = "mean_absolute_error"
)
batch_size <- 32
epochs <- 1000
# Fit model to data
history <- model %>% fit(
  x_train, y_train,
  batch_size = batch_size,
  shuffle = T,
  epochs = epochs,
  validation_data = list(x_test,y_test))

plot(history)
#val is MAE 16 years