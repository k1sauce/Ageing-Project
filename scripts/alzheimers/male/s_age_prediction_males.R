load("~/R/ageing/datasets/alzheimers/males/probe_index.r")
load("~/R/ageing/datasets/alzheimers/males/na_fill_mvalues_male_brain_diseased.r")
load("~/R/ageing/datasets/alzheimers/males/na_fill_mvalues_male_brain_controls.r")
load("~/R/ageing/datasets/alzheimers/males/vec_age_male_controls.r")
load("~/R/ageing/datasets/alzheimers/males/vec_age_male_diseased.r")


tmp <- probe_index
age_yx_controls <- as.matrix(na_fill_mvalues_male_brain_controls[tmp,])
age_yx_controls <- rbind(vec_age_male_controls, age_yx_controls)
rownames(age_yx_controls)[1] <- "age"


control_index <- sample(379, 0.7*379)

age_yx_train_controls <- age_yx_controls[,control_index]
age_yx_test_controls <- age_yx_controls[,-control_index]

save(age_yx_train_controls,file = "~/R/ageing/datasets/alzheimers/males/age_yx_train_controls.r")
save(age_yx_test_controls, file = "~/R/ageing/datasets/alzheimers/males/age_yx_test_controls.r")


#glmnet
load("~/R/ageing/datasets/alzheimers/males/age_yx_train_controls.r")
load("~/R/ageing/datasets/alzheimers/males/age_yx_test_controls.r")
age_yx_train_controls <- t(age_yx_train_controls)
age_yx_test_controls <- t(age_yx_test_controls)

train_glm = cv.glmnet(x = as.matrix(age_yx_train_controls[,2:356]), y = as.matrix(age_yx_train_controls[,1]), family = "gaussian", type.measure = "mse", nfolds = 5, lambda = seq(0.001,0.1,by = 0.001),
                         standardize=FALSE )
plot(train_glm)

train_glm$lambda.min

pr_glm <- predict(train_glm, newx = as.matrix(age_yx_test_controls[,2:356]), type = "class", s = train_glm$lambda.min)

prdf <- cbind(as.numeric(pr_glm), as.numeric(as.character(age_yx_test_controls[,1])))
colnames(prdf) <- c("yhat","y")
prdf <- data.frame(prdf)
prdf$delta <- prdf$y - prdf$yhat 
hist(prdf$delta)
mean(abs(prdf$delta))
cor(x = prdf$y, y = prdf$yhat)

## MAE 4.25
## r = 0.978

# age prediction
library(keras)
library(tensorflow)

# Data Preparation ---------------------------------------------------

load("~/R/ageing/datasets/alzheimers/males/age_yx_train_controls.r")
load("~/R/ageing/datasets/alzheimers/males/age_yx_test_controls.r")

age_yx_train_controls <- t(age_yx_train_controls)
age_yx_test_controls <- t(age_yx_test_controls)

x_train <- as.matrix(age_yx_train_controls[,2:356])
y_train <- as.matrix(age_yx_train_controls[,1])
x_test <- as.matrix(age_yx_test_controls[,2:356])
y_test <- as.matrix(age_yx_test_controls[,1])

# Define Model --------------------------------------------------------------

model <- keras_model_sequential()
model %>% 
  
  layer_dense(units = 355, activation = 'relu', input_shape = c(355)) %>% 
  layer_dropout(rate = 0.2) %>% 
  layer_dense(units = 200, activation = 'relu') %>% 
  layer_dense(units = 1)

summary(model)

model %>% compile(
  loss = 'mse',
  optimizer = "adam",
  metrics = "mean_absolute_error"
)
batch_size <- 32 
epochs <- 100
# Fit model to data
history <- model %>% fit(
  x_train, y_train,
  batch_size = batch_size,
  shuffle = T,
  epochs = epochs,
  validation_data = list(x_test,y_test))

plot(history)

trainagep <- predict(model, x = x_train)
mean(abs(trainagep - y_train))
hist(trainagep - y_train)
cor(y = trainagep, x = y_train)

testagep <- predict(model, x = x_test)
mean(abs(testagep - y_test)) # mean error is 3.5 years
cor(y = testagep, x = y_test) # r - 0.981
plot(y = testagep, x = y_test, xlab = "True Age", ylab = "Predicted Age", main = "Male Prefrontal Cortex - Healthy")
hist(testagep - y_test)


score <- model %>% evaluate(
  x_test, y_test,
  verbose = 0
)

# Output metrics
cat('Test loss:', score[[1]], '\n')
cat('Test accuracy:', score[[2]], '\n')

#age_yx_diseased

tmp <- probe_index
age_yx_diseased <- na_fill_mvalues_male_brain_diseased[tmp,]
age_yx_diseased <- t(age_yx_diseased)
save(age_yx_diseased, file = "~/R/ageing/datasets/alzheimers/males/age_yx_disease.r")
load("~/R/ageing/datasets/alzheimers/males/age_yx_disease.r")
save_model_hdf5(model, filepath = "~/R/ageing/datasets/alzheimers/males/tf_model_male_age.r", overwrite = TRUE,
                include_optimizer = TRUE)
model <- load_model_hdf5(filepath = "~/R/ageing/datasets/alzheimers/males/tf_model_male_age.r", custom_objects = NULL, compile = TRUE)
load("~/R/ageing/datasets/alzheimers/males/vec_age_male_diseased.r")
x_diseased <- as.matrix(age_yx_diseased)
y_diseased <- vec_age_male_diseased

predydis <- predict(model, x = x_diseased)
mean(abs(predydis - y_diseased)) # 4.77 years
plot(y = predydis, x = y_diseased, xlab = "True Age", ylab = "Predicted Age", main = "Male Prefrontal Cortex - Diseased")
cor(y = predydis, x = y_diseased) # r - 0.733
hist(predydis - y_diseased)
# 