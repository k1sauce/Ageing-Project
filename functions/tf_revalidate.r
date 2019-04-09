# to use this function set probe_ptp to the probe of interest and also need to set wd and load yx_train and yx_test

revalidate <- function(batch_size,epochs,fp){
  
  #train data
  yt <- yx_train$y
  xt <- yx_train[,probe_ptp]
  yxt <- cbind(yt,xt)
  colnames(yxt) <- c("y",paste0(probe_ptp))
  
  #validation data
  yv <- yx_test$y
  xv <- yx_test[,probe_ptp]
  yxv <- cbind(yv,xv)
  colnames(yxv) <- c("y",paste0(probe_ptp))
  
  library(keras)
  library(tensorflow)
  
  # Data Preparation ---------------------------------------------------
  
  
  x_train <- as.matrix(yxt[,2:dim(yxt)[2]])
  y_train <- as.matrix(yxt[,1])
  x_test <- as.matrix(yxv[,2:dim(yxv)[2]])
  y_test <- as.matrix(yxv[,1])
  
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
    callbacks = callback_model_checkpoint(filepath = fp, monitor = "val_acc", save_best_only = TRUE),
    validation_data = list(x_test,y_test)
  )
  
  score <- model %>% evaluate(
    x_test, y_test,
    verbose = 0
  )
  
  cat('Test loss:', score[[1]], '\n')
  cat('Test accuracy:', score[[2]], '\n')
  acc <- score[[2]]
  return(list(acc, model))
}