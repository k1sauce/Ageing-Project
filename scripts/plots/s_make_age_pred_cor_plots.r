#RA FEMALES
raf <- c("~/R/ageing/datasets/rheumatoid_arthritis/females/tf_model_female_age.r",
"~/R/ageing/datasets/rheumatoid_arthritis/females/age_yx_test_controls.r")
#RA MALES
ram <- c("~/R/ageing/datasets/rheumatoid_arthritis/males/tf_model_male_age.r",
"~/R/ageing/datasets/rheumatoid_arthritis/males/age_yx_test_controls.r")
#AD FEMALES
adf <- c("~/R/ageing/datasets/alzheimers/females/tf_model_female_age.r",
"~/R/ageing/datasets/alzheimers/females/age_yx_test_controls.r")
#AD MALES
adm <- c("~/R/ageing/datasets/alzheimers/males/tf_model_male_age.r",
"~/R/ageing/datasets/alzheimers/males/age_yx_test_controls.r")
#NAFLD FEMALES
naf <- c("~/R/ageing/datasets/nafld/females/tf_model_female_age.r",
"~/R/ageing/datasets/nafld/females/age_yx_test_controls.r")
#NAFLD MALES
nam <- c("~/R/ageing/datasets/nafld/males/tf_model_male_age.r",
"~/R/ageing/datasets/nafld/males/age_yx_test_controls.r")


filelist <- list(raf,ram,adf,adm,naf,nam)

# load the model, load the yx test of controls, output true age and predicted age
source("~/R/ageing/functions/age_and_page.r")
age_and_page_list <- list()
for (files in filelist){
  df <- age_and_page(model = files[1], fp = files[2])
  age_and_page_list <- c(age_and_page_list, df)
}
names(age_and_page_list) <- c('raf','rafp','ram','ramp','adf','adfp','adm','admp','naf','nafp','nam','namp')
save(age_and_page_list, file = "~/R/ageing/datasets/Plot_data/age_and_page_list.r")
load("~/R/ageing/datasets/Plot_data/age_and_page_list.r")
#plot
source("~/R/ageing/functions/plot_age.r")
#RAF
praf <- plot_age(age_and_page_list$raf, age_and_page_list$rafp, xlab = "Sample Age",
              ylab = "Predicted Age", ggtitle = "A - Female Blood Samples \nValidation Set Age vs Predicted Age",
              shape = 70,
              pointsize = 0.5,
              textsize = 5)
#RAM
pram <- plot_age(age_and_page_list$ram, age_and_page_list$ramp, xlab = "Sample Age",
              ylab = "Predicted Age", ggtitle = "B - Male Blood Samples \nValidation Set Age vs Predicted Age",
              shape=77,
              pointsize = 0.5,
              textsize = 5)
#ADF
padf <- plot_age(age_and_page_list$adf, age_and_page_list$adfp, xlab = "Sample Age",
              ylab = "Predicted Age", ggtitle = "C - Female Brain Samples \nValidation Set Age vs Predicted Age",
              shape=70,
              pointsize = 0.5,
              textsize = 5)
#ADM
padm <- plot_age(age_and_page_list$adm, age_and_page_list$admp, xlab = "Sample Age",
              ylab = "Predicted Age", ggtitle = "D - Male Brain Samples \nValidation Set Age vs Predicted Age",
              shape=77,
              pointsize = 0.5,
              textsize = 5)
#NAF
pnaf <- plot_age(age_and_page_list$naf, age_and_page_list$nafp, xlab = "Sample Age",
              ylab = "Predicted Age", ggtitle = "E - Female Liver Samples \nValidation Set Age vs Predicted Age",
              shape=70,
              pointsize = 0.5,
              textsize = 5)
#NAM
pnam <- plot_age(age_and_page_list$nam, age_and_page_list$namp, xlab = "Sample Age",
              ylab = "Predicted Age", ggtitle = "F - Male Liver Samples \nValidation Set Age vs Predicted Age",
              shape=77,
              pointsize = 0.5,
              textsize = 5)

#grid.arrange(praf, padf, pnaf, pram, padm, pnam, ncol=3)
gggg <- arrangeGrob(praf, padf, pnaf, pram, padm, pnam, ncol=3)
ggsave(filename = "~/R/ageing/datasets/Plot_data/age_pred_cor_plots.png",
       plot = gggg,
       device = png(),
       width = 160,
       height = 100,
       units = "mm",
       dpi = 320)
