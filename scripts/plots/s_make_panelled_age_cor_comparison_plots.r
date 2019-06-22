library('keras')
library('tensorflow')
library('ggplot2')
library('gridExtra')
library('reshape')

loadRData <- function(fileName){
  #loads an RData file, and returns it
  load(fileName)
  get(ls()[ls() != "fileName"])
}

make_plot_matrix <- function(files){
  #loads age_yx_test_controls
  age_yx_test_controls <- loadRData(files[2])
  model <- file.path(files[1])
  model <- load_model_hdf5(filepath = model, custom_objects = NULL, compile = TRUE)
  age_yx_test_controls <- t(age_yx_test_controls)
  x_test <- as.matrix(age_yx_test_controls[,2:ncol(age_yx_test_controls)])
  y_test <- as.matrix(age_yx_test_controls[,1])
  testagep <- predict(model, x = x_test)
  m <- data.frame(cbind(y_test,testagep))
  colnames(m) <- c("age","page")
  
  horvath_age <- loadRData(files[3])
  sum(rownames(m) == names(horvath_age)) == dim(m)[1]
  m <- cbind(m, horvath_age)
  horvath_age_control <- horvath_age
  m <- as.data.frame(m)
  m <- cbind(rownames(m),m)
  colnames(m)[1] <- "GSM"
  m <- melt(m, id=c("age","GSM"))
  return(m)
}

make_age_cor_comparison_plots <- function(m, title){
  p <- ggplot(data = m, aes(x=m$age, y=m$value, color=m$variable)) + 
    geom_point(alpha=0.5) +
    geom_smooth(method = lm, se=FALSE, size=0.3) +
    xlim(0,max(m$age)) + ylim(0,max(m$value)) + 
    geom_abline(slope = 1, intercept = 0, linetype=2, size=0.3) +
    xlab("Age") + ylab("Predicted Age") +
    scale_colour_manual(name="Model", labels=c("Nueral Net", "Horvath"), values=c("#F8766D", "#00BFC4")) +
    ggtitle(title) + 
    theme_minimal() +
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank(), axis.line = element_line(colour = "black"))
  return(p)
}

#RA FEMALES
model_files_raf <- c("~/R/ageing/datasets/rheumatoid_arthritis/females/tf_model_female_age.r",
         "~/R/ageing/datasets/rheumatoid_arthritis/females/age_yx_test_controls.r",
         "~/R/ageing/datasets/rheumatoid_arthritis/females/age_yx_test_controls_horvath_estimate.r")
title_raf <- "Model Comparison - Female blood controls"
m_raf <- make_plot_matrix(files = model_files_raf)
#RA MALES
model_files_ram <- c("~/R/ageing/datasets/rheumatoid_arthritis/males/tf_model_male_age.r",
                 "~/R/ageing/datasets/rheumatoid_arthritis/males/age_yx_test_controls.r",
                 "~/R/ageing/datasets/rheumatoid_arthritis/males/age_yx_test_controls_horvath_estimate.r")
title_ram <- "Model Comparison - Male blood controls"
m_ram <- make_plot_matrix(files = model_files_ram)
#AD FEMALES
model_files_adf <- c("~/R/ageing/datasets/alzheimers/females/tf_model_female_age.r",
                     "~/R/ageing/datasets/alzheimers/females/age_yx_test_controls.r",
                     "~/R/ageing/datasets/alzheimers/females/age_yx_test_controls_horvath_estimate.r")
title_adf <- "Model Comparison - Female brain controls"
m_adf <- make_plot_matrix(files = model_files_adf)
#AD MALES
model_files_adm <- c("~/R/ageing/datasets/alzheimers/males/tf_model_male_age.r",
                     "~/R/ageing/datasets/alzheimers/males/age_yx_test_controls.r",
                     "~/R/ageing/datasets/alzheimers/males/age_yx_test_controls_horvath_estimate.r")
title_adm <- "Model Comparison - Male brain controls"
m_adm <- make_plot_matrix(files = model_files_adm)
#NAFLD FEMALES
model_files_lf <- c("~/R/ageing/datasets/nafld/females/tf_model_female_age.r",
                     "~/R/ageing/datasets/nafld/females/age_yx_test_controls.r",
                     "~/R/ageing/datasets/nafld/females/age_yx_test_controls_horvath_estimate.r")
title_lf <- "Model Comparison - Female liver controls"
m_lf <- make_plot_matrix(files = model_files_lf)
#NAFLD MALES
model_files_lm <- c("~/R/ageing/datasets/nafld/males/tf_model_male_age.r",
                    "~/R/ageing/datasets/nafld/males/age_yx_test_controls.r",
                    "~/R/ageing/datasets/nafld/males/age_yx_test_controls_horvath_estimate.r")
title_lm <- "Model Comparison - Male liver controls"
m_lm <- make_plot_matrix(files = model_files_lm)
###

praf <- make_age_cor_comparison_plots(m = m_raf, title = title_raf)
pram <- make_age_cor_comparison_plots(m = m_ram, title = title_ram)
padf <- make_age_cor_comparison_plots(m = m_adf, title = title_adf)
padm <- make_age_cor_comparison_plots(m = m_adm, title = title_adm)
pnaf <- make_age_cor_comparison_plots(m = m_lf, title = title_lf)
pnam <- make_age_cor_comparison_plots(m = m_lm, title = title_lm)



gggg <- arrangeGrob(praf, padf, pnaf, pram, padm, pnam, ncol=3)
ggsave(filename = "~/R/ageing/datasets/Plot_data/age_cor_comparison_plots_latest.png",
       plot = gggg,
       device = png(),
       width = 640,
       height = 400,
       units = "mm",
       dpi = 320)
