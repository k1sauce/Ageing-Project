probe_ptp <- c("cg24500428","cg22730626","cg06890761","cg13909612")
load("~/R/ageing/datasets/rheumatoid_arthritis/females/yx_train.r")
load("~/R/ageing/datasets/rheumatoid_arthritis/females/yx_test.r")
source("~/R/ageing/functions/tf_revalidate.r")
model <- revalidate(32,3500, fp="~/Downloads/weights.{epoch:02d}-{val_acc:.2f}.hdf5")
model <- load_model_hdf5("~/Downloads/weights.1330-0.66.hdf5")

#validation data
yv <- yx_test$y
xv <- yx_test[,probe_ptp]
yxv <- cbind(yv,xv)
colnames(yxv) <- c("y",paste0(probe_ptp))

x_test <- as.matrix(yxv[,2:dim(yxv)[2]])
y_test <- as.matrix(yxv[,1])

tmp <- predict(model, x_test)

pr_nn <- predict(model,x_test)
prdf <- cbind(pr_nn,y_test)
prdf <- data.frame(prdf)
prdf$delta <- prdf[,1] - prdf[,2]
prdf <- prdf[order(-prdf$X1),]
rank <- rev(seq_along(prdf$X1))
rocobject <- roc(prdf$X2, rank, plot = F)

library(pROC)

ggroc(rocobject) +
  ggtitle("A - RA/Healthy Females \nValidation Set ROC - PTPRN2 set probes only") +
  geom_abline(intercept = 1, slope = 1, color = "red", linetype="dashed", size=0.3)  +
  theme(legend.position = "none", 
        plot.title = element_text(size = 8), text = element_text(size=8))
# Age plots

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


#val is MAE 4 years
pr_nn <- predict(model,x_test)
prdf <- cbind(pr_nn,y_test)
prdf <- data.frame(prdf)
plot(prdf$X1 ~ prdf$X2, xlab="Age", ylab = "Predicted Age", main= "PTPRN2 Set Probes Neural Network Age Estimation")
abline(a = 0, b = 1)
