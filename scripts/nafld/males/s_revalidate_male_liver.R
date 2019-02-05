#set the probe
probe_ptp<- "cg08954025"
#set the correct dir
setwd("~/R/ageing/datasets/nafld/males")
#load the data
load("yx_train.r")
load("yx_test.r")
# run the revalidation
source("~/R/ageing/functions/revalidate.r")
revalidate()
# 0.8214 accuracy

#predict age with the marker
load("~/R/ageing/datasets/nafld/males/age_yx_train_controls.r")
load("~/R/ageing/datasets/nafld/males/age_yx_test_controls.r")

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
#val is MAE 14 years

######################################
#####################################
trainagep <- predict(model, x = x_train)
mean(abs(trainagep - y_train))
hist(trainagep - y_train)
cor(y = trainagep, x = y_train)

testagep <- predict(model, x = x_test)
mean(abs(testagep - y_test)) 
cor(y = testagep, x = y_test) 
plot(y = testagep, x = y_test, xlab = "True Age", ylab = "Predicted Age", main = "Male Liver - Healthy")
hist(testagep - y_test)

plot(y=age_yx_train_controls[,"age"], x=age_yx_train_controls[,probe_ptp])
m = lm(age ~ cg08954025, data = data.frame(age_yx_train_controls)) #r = 0.67
p = predict(m, newdata= data.frame(cg08954025 = age_yx_test_controls[,"cg08954025"]))
mean(abs(p - age_yx_test_controls[,"age"])) #14
plot(x=age_yx_test_controls[,"age"], y=age_yx_test_controls[,"cg08954025"])
abline(m)
cor(x=age_yx_test_controls[,"age"],p)
