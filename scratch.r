










library(dplyr)
library(multipanelfigure)
library(jpeg)

library(multipanelfigure)
figure <- multi_panel_figure(width = 100, height = 100,
                             rows = 1, columns = 1)
figure %<>% fill_panel(p)
figure


%>%
  fill_panel(, column = 2:3) %>%
  fill_panel(, row = 2:3) %>%
  fill_panel(, column = 2:3, row = 2:3)


model <- load_model_hdf5(filepath = "~/R/ageing/datasets/rheumatoid_arthritis/females/tf_model_female_age.r", custom_objects = NULL, compile = TRUE)
load("~/R/ageing/datasets/rheumatoid_arthritis/females/age_yx_test_controls.r")
age_yx_test_controls <- t(age_yx_test_controls)
x_test <- as.matrix(age_yx_test_controls[,2:322])
y_test <- as.matrix(age_yx_test_controls[,1])

testagep <- predict(model, x = x_test)
plot(y = testagep, x = y_test, xlab = "True Age", ylab = "Predicted Age", main = "Female Arthritis - Healthy", pch="F", alpha=0.5, nr)
PLOT <- smoothScatter(y_test,testagep, colramp=colorRampPalette(c("white", brewer.pal(9, "Blues"))), pch = "F", cex= 0.5, col = alpha("red", 0.7), nrpoints = Inf)
abline( lm( testagep ~ y_test), lty = 2, col="red", lwd=2 )
abline(0,1, col="black", lty = 1, lwd=2)

df <- data.frame(cbind(y_test, testagep))
colnames(df) <- c("Age", "P")
ggplot(df, aes(y = P, x = Age)) +
  stat_density2d(aes(fill = ..density..), geom = "tile", contour = FALSE, n = 200) +
  scale_fill_continuous(low = "white", high = "dodgerblue4") +
  scale_shape_identity() +
  geom_point(alpha =0.5, color="red", aes(shape=70)) +
  geom_smooth(method = 'lm', color = "red", linetype="dashed", size = 0.3, se=F) +
  geom_abline(intercept = 0, slope = 1, color = "black", size=0.3) + 
  xlim(0,100) + 
  ylim(0,100) +
  xlab("Sample Age") +
  ylab("Preicted Age") +
  ggtitle("Female Blood Samples Validation Set Age vs Predicted Age") +
  theme(legend.position = "none")

ggplot(data = dat, aes(x, y)) +   
  stat_density2d(aes(fill = ..density..^0.25), geom = "tile", contour = FALSE, n = 200) +  
  scale_fill_continuous(low = "white", high = "dodgerblue4")


load("~/R/ageing/datasets/rheumatoid_arthritis/females/age_yx_disease.r")
load("~/R/ageing/datasets/rheumatoid_arthritis/females/vec_age_female_diseased.r")
x_diseased <- as.matrix(age_yx_diseased)
y_diseased <- vec_age_female_diseased
model <- load_model_hdf5(filepath = "~/R/ageing/datasets/rheumatoid_arthritis/females/tf_model_female_age.r", custom_objects = NULL, compile = TRUE)
predydis <- predict(model, x = x_diseased)

plot(y = predydis, x = y_diseased, xlab = "True Age", ylab = "Predicted Age", main = "Female Arthritis - Diseased", pch="F")
