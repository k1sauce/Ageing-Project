#RA FEMALES
raf <- c("~/R/ageing/datasets/rheumatoid_arthritis/females/tf_model_female_age.r",
         "~/R/ageing/datasets/rheumatoid_arthritis/females/age_yx_test_controls.r",
         "~/R/ageing/datasets/rheumatoid_arthritis/females/age_yx_test_controls_horvath_estimate.r")


fp <- file.path(raf[2])
load(fp)
model <- file.path(raf[1])
model <- load_model_hdf5(filepath = model, custom_objects = NULL, compile = TRUE)
age_yx_test_controls <- t(age_yx_test_controls)
x_test <- as.matrix(age_yx_test_controls[,2:ncol(age_yx_test_controls)])
y_test <- as.matrix(age_yx_test_controls[,1])
testagep <- predict(model, x = x_test)
m <- data.frame(cbind(y_test,testagep))
colnames(m) <- c("age","page")

load(raf[3])
sum(rownames(m) == names(horvath_age)) == dim(m)[1]
m <- cbind(m, horvath_age)
horvath_age_control <- horvath_age
m <- as.data.frame(m)
m <- cbind(rownames(m),m)
colnames(m)[1] <- "GSM"
mtab <- m



library(reshape)
m <- melt(m, id=c("age","GSM"))

ggplot(data = m, aes(x=m$age, y=m$value, color=m$variable)) + 
  geom_point(alpha=0.5) +
  geom_smooth(method = lm, se=FALSE, size=0.3) +
  xlim(0,max(m$age)) + ylim(0,max(m$value)) + 
  geom_abline(slope = 1, intercept = 0, linetype=2, size=0.3) +
  xlab("Age") + ylab("Predicted Age") +
  scale_colour_manual(name="Model", labels=c("Nueral Net", "Horvath"), values=c("#F8766D", "#00BFC4")) +
  ggtitle("Model Comparison - Female blood controls")


### disease
raf_d <- c("~/R/ageing/datasets/rheumatoid_arthritis/females/vec_age_female_diseased.r", 
           "~/R/ageing/datasets/rheumatoid_arthritis/females/GSE42861_ra/female_diseased_betas_horvath_estimate.r",
           "~/R/ageing/datasets/rheumatoid_arthritis/females/age_yx_disease_page_estimate.r")
load(raf_d[1])
age <- vec_age_female_diseased
load(raf_d[2])
load(raf_d[3])
sum(names(horvath_age) == names(page)) == length(age)
m <- cbind(age, page, horvath_age)
colnames(m) <- c("age","page","horvath_age")
m <- as.data.frame(m)
m <- cbind(rownames(m),m)
colnames(m)[1] <- "GSM"
mtab <- m

library(reshape)
m <- melt(m, id=c("age","GSM"))

ggplot(data = m, aes(x=m$age, y=m$value, color=m$variable)) + 
  geom_point() +
  geom_smooth(method = lm) +
  xlim(0,max(m$age)) + ylim(0,max(m$value)) + 
  geom_abline(slope = 1, intercept = 0, linetype=2) +
  xlab("Age") + ylab("Predicted Age") +
  scale_colour_manual(name="Model", labels=c("Nueral Net", "Horvath"), values=c("#F8766D", "#00BFC4")) +
  ggtitle("Model Comparison - RA Females")



