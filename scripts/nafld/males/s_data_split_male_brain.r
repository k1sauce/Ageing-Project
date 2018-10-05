load("~/R/ageing/datasets/rheumatoid_arthritis/males/na_fill_mvalues_male_blood_controls.r")
load("~/R/ageing/datasets/rheumatoid_arthritis/males/na_fill_mvalues_male_blood_diseased.r")

na_fill_mvalues_male_blood_controls <- t(na_fill_mvalues_male_blood_controls)
na_fill_mvalues_male_blood_diseased <- t(na_fill_mvalues_male_blood_diseased)

control_index <- sample(2656, 0.7*2656)
disease_index <- sample(101, 0.7*101)

control_train <- na_fill_mvalues_male_blood_controls[control_index,]
disease_train <- na_fill_mvalues_male_blood_diseased[disease_index,]

control_test <- na_fill_mvalues_male_blood_controls[-control_index,]
disease_test <- na_fill_mvalues_male_blood_diseased[-disease_index,]

x_train <- rbind(control_train,disease_train)
y_train <- data.frame(c(rep(0,1859),rep(1,70)))
yx_train <- cbind(y_train,x_train)
colnames(yx_train)[1] <- "y"
setwd("~/R/ageing/datasets/rheumatoid_arthritis/males")
save(yx_train, file = "yx_train.r")

x_test <- rbind(control_test, disease_test)
y_test <- data.frame(c(rep(0,797),rep(1,31)))
yx_test <- cbind(y_test,x_test)
colnames(yx_test)[1] <- "y"
setwd("~/R/ageing/datasets/rheumatoid_arthritis/males")
save(yx_test, file = "yx_test.r")


