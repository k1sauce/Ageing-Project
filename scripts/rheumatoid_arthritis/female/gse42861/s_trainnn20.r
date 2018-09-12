# 21 probes given by elastic net regression give 80% acc predicting disease in test set 
# but cannot predict age well
#
# NN should be able to do 80 % or better
# Can 21 probes give 80% acc in nn
# if so can more probes increase this acc
#
# can the larger probe set better predict age
# we should also aim to have 300 probes to predict age

load("~/R/ageing/datasets/rheumatoid_arthritis/males/GSE42861_ra/ra_prediction_probes_males.r")
yx_train20 <- yx_train[,names(ra_prediction_probes_males)[-1]]
yx_train20 <- cbind(yx_train$y,yx_train20)
colnames(yx_train20)[1] <- "y"
yx_test20 <- yx_test[,names(ra_prediction_probes_males)[-1]]
yx_test20 <- cbind(yx_test$y,yx_test20)
colnames(yx_test20)[1] <- "y"

x_train <- as.matrix(yx_train20[,2:21])
y_train <- as.matrix(yx_train20[,1])
x_test <- as.matrix(yx_test20[,2:21])
y_test <- as.matrix(yx_test20[,1])

model <- keras_model_sequential()
model %>% 
  
  layer_dense(units = 20, activation = 'relu', input_shape = c(20)) %>% 
  layer_dense(units = 1)

summary(model)

model %>% compile(
  loss = 'mse',
  optimizer = "adam",
  metrics = c('accuracy')
)
batch_size <- 20 
epochs <- 1000
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
