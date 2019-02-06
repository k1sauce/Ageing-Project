age_and_page <- function(model, fp){
  fp <- file.path(fp)
  load(fp)
  model <- file.path(model)
  model <- load_model_hdf5(filepath = model, custom_objects = NULL, compile = TRUE)
  age_yx_test_controls <- t(age_yx_test_controls)
  x_test <- as.matrix(age_yx_test_controls[,2:ncol(age_yx_test_controls)])
  y_test <- as.matrix(age_yx_test_controls[,1])
  testagep <- predict(model, x = x_test)
  m <- data.frame(cbind(y_test,testagep))
  colnames(m) <- c("age","page")
  return(m)
}