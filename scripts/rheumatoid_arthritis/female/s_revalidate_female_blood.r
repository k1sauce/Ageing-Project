#set the probe
probe_ptp <- c("cg24500428","cg22730626","cg06890761","cg13909612")
#set the correct dir
setwd("~/R/ageing/datasets/rheumatoid_arthritis/females")
#load the data
load("~/R/ageing/datasets/rheumatoid_arthritis/females/yx_train.r")
load("~/R/ageing/datasets/rheumatoid_arthritis/females/yx_test.r")
# run the revalidation
source("~/R/ageing/functions/tf_revalidate.r")
revalidate()
# 0.65 accuracy

#predict age with the marker
load("~/R/ageing/datasets/rheumatoid_arthritis/females/age_yx_train_controls.r")
load("~/R/ageing/datasets/rheumatoid_arthritis/females/age_yx_test_controls.r")

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
  
  layer_dense(units = 100, activation = 'relu', input_shape = c(4)) %>% 
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
batch_size <- 16 
epochs <- 200
# Fit model to data
history <- model %>% fit(
  x_train, y_train,
  batch_size = batch_size,
  shuffle = T,
  epochs = epochs,
  validation_data = list(x_test,y_test))

plot(history)
#val is MAE 4 years