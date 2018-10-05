meta_controls <- read.csv(file="~/R/ageing/datasets/nafld/males/sample_description_table_mc_fl.csv",sep=",")
meta_diseased <- read.csv(file = "sample_description_table_male_diseased_liver.csv",sep = ",")

load("~/R/ageing/datasets/nafld/males/na_fill_mvalues_male_liver_controls.r")
load("~/R/ageing/datasets/nafld/males/na_fill_mvalues_male_liver_diseased.r")


#male_liver_diseased_data_set <- c(rep(9,16),rep(13,54))
#save(male_liver_diseased_data_set, file="male_liver_diseased_data_set.r")



na_fill_table <- cbind(na_fill_mvalues_male_liver_controls, na_fill_mvalues_male_liver_diseased)
na_fill_table <- t(na_fill_table)
y_fill_table <- c(meta_controls$dataset,meta_diseased$dataset)

dataset_data <- cbind(y_fill_table,na_fill_table)
colnames(dataset_data)[1] <- "y"

index <- sample(88, 0.7*88)
setwd("~/R/ageing/datasets/nafld/males")
save(index, file = "nn_confound_test_dataset_index.r")

train <- dataset_data[index,]
test <- dataset_data[-index,]

library(neuralnet)
n <- colnames(train)
f <- as.formula(paste("y ~", paste(n[!n %in% "y"], collapse = " + ")))
nn <- neuralnet(f,data=train,hidden=c(200,100,10), linear.output =T, err.fct = "sse")
setwd("~/R/ageing/datasets/nafld/males")
save(nn, file = "nn_confound_test_dataset.r")
delta <- as.numeric(data.frame(nn$net.result)[,1])-as.numeric(nn$response)
sum(abs(delta>1))

pr_nn <- compute(nn,test[,2:5001])
prdf <- cbind(pr_nn$net.result,test[,1])
prdf <- data.frame(prdf)
prdf$delta <- prdf$X2 - prdf$X1 
hist(prdf$delta)
sum(abs(prdf$delta)>1)

#27% accuracy
###