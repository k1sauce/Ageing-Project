# can the data set determine the outcome?
# the RA dataset is GSE42681
# Take all names from RA dataset and use this to subset na_fill tables, assign y as 1 value
# Take the complement of the RA dataset names, assign y as 0 values

load("~/R/ageing/datasets/rheumatoid_arthritis/females/na_fill_mvalues_female_blood_controls.r")
load("~/R/ageing/datasets/rheumatoid_arthritis/females/na_fill_mvalues_female_blood_diseased.r")
load("~/R/ageing/datasets/rheumatoid_arthritis/males/GSE42861_ra/GSE42861_ra.r")

ratmp <- data.frame(as.character(ra[[2]]), as.character(ra[[14]]))
raf <- subset(ratmp, ratmp[,2] == "gender: f")
GSE42861IDs <- as.character(raf[,1])
rm(ra)
load("~/R/ageing/datasets/rheumatoid_arthritis/females/yx_train_gw.r")
gw_probes <- colnames(yx_train_gw)[2:468]

na_fill_table <- cbind(na_fill_mvalues_female_blood_controls, na_fill_mvalues_female_blood_diseased)
na_fill_table <- na_fill_table[gw_probes,]

mts <- match(GSE42861IDs, colnames(na_fill_table))

gse42681_na_fill_gw <- na_fill_table[,mts]
gse42681_complement_na_fill_gw <- na_fill_table[,-mts]

gse42681_na_fill_gw <- t(gse42681_na_fill_gw)
gse42681_complement_na_fill_gw <- t(gse42681_complement_na_fill_gw)

mix_index <- sample(2560, 0.7*2560)
single_index <- sample(197, 0.7*197)

mix_train <- gse42681_complement_na_fill_gw[mix_index,]
single_train <- gse42681_na_fill_gw[single_index,]

mix_test <- gse42681_complement_na_fill_gw[-mix_index,]
single_test <- gse42681_na_fill_gw[-single_index,]

x_train <- rbind(mix_train,single_train)
y_train <- data.frame(c(rep(0,1792),rep(1,137)))
yx_train_datasets <- cbind(y_train,x_train)
colnames(yx_train_datasets)[1] <- "y"
setwd("~/R/ageing/datasets/rheumatoid_arthritis/females")
save(yx_train_datasets, file = "yx_train_datasets_confounding_check.r")

x_test <- rbind(mix_test, single_test)
y_test <- data.frame(c(rep(0,768),rep(1,60)))
yx_test_datasets <- cbind(y_test,x_test)
colnames(yx_test_datasets)[1] <- "y"
setwd("~/R/ageing/datasets/rheumatoid_arthritis/females")
save(yx_test_datasets, file = "yx_test_datasets_confounding_check.r")

load("~/R/ageing/datasets/rheumatoid_arthritis/females/yx_train_datasets_confounding_check.r")
library(neuralnet)
# train the nn on the training data
n <- colnames(yx_train_datasets)
f <- as.formula(paste("y ~", paste(n[!n %in% "y"], collapse = " + ")))
nn <- neuralnet(f,data=yx_train_datasets,hidden=c(200),linear.output=F, act.fct = "logistic", err.fct = "ce")
save(nn, file="nn_yx_train_datasets.r")

# quick check on the classification performance
delta <- as.numeric(data.frame(nn$net.result)[,1])-as.numeric(nn$response)
sum(abs(delta>0.5))

load("~/R/ageing/datasets/rheumatoid_arthritis/females/yx_test_datasets_confounding_check.r")
pr_nn <- compute(nn,yx_test_datasets[,2:468])
prdf <- cbind(pr_nn$net.result,yx_test_datasets[,1])
prdf <- data.frame(prdf)
prdf$delta <- prdf$X2 - prdf$X1 
hist(prdf$delta)
sum(abs(prdf$delta) > 0.5)

#correctly identifies the single dataset 54/60 times, so confounded


