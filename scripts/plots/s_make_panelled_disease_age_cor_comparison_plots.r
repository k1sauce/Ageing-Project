### disease

library(reshape)

# make matrix
loadRData <- function(fileName){
  #loads an RData file, and returns it
  load(fileName)
  get(ls()[ls() != "fileName"])
}

make_plot_matrix <- function(files) {
  age <- loadRData(files[1])
  horvath_age <- loadRData(files[2])
  page <- loadRData(files[3])
  if (!sum(names(horvath_age) == names(page)) == length(age)) stop("files are bad")
  m <- cbind(age, page, horvath_age)
  colnames(m) <- c("age","page","horvath_age")
  m <- as.data.frame(m)
  m <- cbind(rownames(m),m)
  colnames(m)[1] <- "GSM"
  m <- melt(m, id=c("age","GSM"))
  return(m)
}

make_disease_age_prediction_comparison_plots <- function(m, title_text){
  g <- ggplot(data = m, aes(x=m$age, y=m$value, color=m$variable)) + 
          geom_point() +
          geom_smooth(method = lm) +
          xlim(min(m$age),max(m$age)) + ylim(min(m$value),max(m$value)) + 
          geom_abline(slope = 1, intercept = 0, linetype=2) +
          xlab("Age") + ylab("Predicted Age") +
          scale_colour_manual(name="Model", labels=c("Nueral Net", "Horvath"), values=c("#F8766D", "#00BFC4")) +
          ggtitle(label = title_text)
  return(g)
}

#raf_d
raf_d <- c("~/R/ageing/datasets/rheumatoid_arthritis/females/vec_age_female_diseased.r", 
           "~/R/ageing/datasets/rheumatoid_arthritis/females/GSE42861_ra/female_diseased_betas_horvath_estimate.r",
           "~/R/ageing/datasets/rheumatoid_arthritis/females/age_yx_disease_page_estimate.r")
title_raf_d = "Age Prediction Model Comparison - RA Females"
m_raf_d <- make_plot_matrix(raf_d)
#ram_d

ram_d <- c("~/R/ageing/datasets/rheumatoid_arthritis/males/vec_age_male_blood_diseased.r", 
           "~/R/ageing/datasets/rheumatoid_arthritis/males/GSE42861_ra/male_diseased_betas_horvath_estimate.r",
           "~/R/ageing/datasets/rheumatoid_arthritis/males/age_yx_disease_page_estimate.r")
title_ram_d = "Age Prediction Model Comparison - RA Males"
m_ram_d <- make_plot_matrix(ram_d)

#adf_d

adf_d <- c("~/R/ageing/datasets/alzheimers/females/vec_age_female_diseased.r", 
           "~/R/ageing/datasets/alzheimers/females/female_diseased_betas_horvath_estimate.r",
           "~/R/ageing/datasets/alzheimers/females/age_yx_disease_page_estimate.r")
title_adf_d = "Age Prediction Model Comparison - AD Females"
m_adf_d <- make_plot_matrix(adf_d)

#adm_d

adm_d <- c("~/R/ageing/datasets/alzheimers/males/vec_age_male_diseased.r", 
           "~/R/ageing/datasets/alzheimers/males/male_diseased_betas_horvath_estimate.r",
           "~/R/ageing/datasets/alzheimers/males/age_yx_disease_page_estimate.r")
title_adm_d <- "Age Prediction Model Comparison - AD Males"
m_adm_d <- make_plot_matrix(adm_d)

#naf_d

naf_d <- c("~/R/ageing/datasets/nafld/females/vec_age_female_diseased.r", 
           "~/R/ageing/datasets/nafld/females/female_diseased_betas_horvath_estimate.r",
           "~/R/ageing/datasets/nafld/females/age_yx_disease_page_estimate.r")
title_naf_d <- "Age Prediction Model Comparison - NAFLD Females"
m_naf_d <- make_plot_matrix(naf_d)
#nam_d


nam_d <- c("~/R/ageing/datasets/nafld/males/vec_age_male_diseased.r", 
           "~/R/ageing/datasets/nafld/males/male_diseased_betas_horvath_estimate.r",
           "~/R/ageing/datasets/nafld/males/age_yx_disease_page_estimate.r")
title_nam_d <- "Age Prediction Model Comparison - NAFLD Males"
m_nam_d <- make_plot_matrix(nam_d)


praf <- make_disease_age_prediction_comparison_plots(m_raf_d, title_text =  title_raf_d)
pram <- make_disease_age_prediction_comparison_plots(m_ram_d, title_text =  title_ram_d)
padf <- make_disease_age_prediction_comparison_plots(m_adf_d, title_text =  title_adf_d)
padm <- make_disease_age_prediction_comparison_plots(m_adm_d, title_text =  title_adm_d)
pnaf <- make_disease_age_prediction_comparison_plots(m_naf_d, title_text =  title_naf_d)
pnam <- make_disease_age_prediction_comparison_plots(m_nam_d, title_text =  title_nam_d)

gggg <- arrangeGrob(praf, padf, pnaf, pram, padm, pnam, ncol=3)
ggsave(filename = "~/R/ageing/datasets/Plot_data/diseased_age_cor_comparison_plots.png",
       plot = gggg,
       device = png(),
       width = 640,
       height = 400,
       units = "mm",
       dpi = 320)




