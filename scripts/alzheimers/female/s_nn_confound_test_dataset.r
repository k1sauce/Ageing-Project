meta_controls <- read.csv(file="~/R/ageing/datasets/alzheimers/females/sample_description_table_fc_ad.csv",sep=",")
load("~/R/ageing/datasets/alzheimers/females/na_fill_mvalues_female_brain_controls.r")
load("~/R/ageing/datasets/alzheimers/females/na_fill_mvalues_female_brain_diseased.r")

#setwd("~/R/ageing/datasets/alzheimers/females/female_diseased")
#load("fd13.r")
#fd13 <- female_diseased
#p <- phenoData(fd13)
#p13 <- p@data
#
#load("fd3.r")
#fd3 <- female_diseased
#p <- phenoData(fd3)
#p3 <- p@data
#cannot use p3
#
#load("fd9.r")
#fd9 <- female_diseased
#fd9[[2]]
#p <- phenoData(fd9)
#p9 <- p@data

n <- colnames(na_fill_mvalues_female_brain_diseased)

# diseased data is from two geo series
# data set 9 == 16 subjects of GSE72778
# data set 13 == 	54 subjects of GSE80970
female_brain_diseased_data_set <- c(rep(9,16),rep(13,54))
save(female_brain_diseased_data_set, file="female_brain_diseased_data_set.r")



na_fill_table <- cbind(na_fill_mvalues_female_brain_controls, na_fill_mvalues_female_brain_diseased)
na_fill_table <- t(na_fill_table)
y_fill_table <- c(meta_controls$dataset,female_brain_diseased_data_set)

dataset_data <- cbind(y_fill_table,na_fill_table)
colnames(dataset_data)[1] <- "y"

index <- sample(299, 0.7*299)
setwd("~/R/ageing/datasets/alzheimers/females/female_diseased")
save(index, file = "nn_confound_test_dataset_index.r")

train <- dataset_data[index,]
test <- dataset_data[-index,]

library(neuralnet)
n <- colnames(train)
f <- as.formula(paste("y ~", paste(n[!n %in% "y"], collapse = " + ")))
nn <- neuralnet(f,data=train,hidden=c(200,100,10), linear.output =T, err.fct = "sse")
setwd("~/R/ageing/datasets/alzheimers/females/female_diseased")
save(nn, file = "nn_confound_test_dataset.r")
delta <- as.numeric(data.frame(nn$net.result)[,1])-as.numeric(nn$response)
sum(abs(delta>0.5))

pr_nn <- compute(nn,test[,2:5001])
prdf <- cbind(pr_nn$net.result,test[,1])
prdf <- data.frame(prdf)
prdf$delta <- prdf$X2 - prdf$X1 
hist(prdf$delta)
sum(abs(prdf$delta)>0.5)

#69% accuracy
###