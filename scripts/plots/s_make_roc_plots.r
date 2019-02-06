#RAF
raf <- c("~/R/ageing/datasets/rheumatoid_arthritis/females/probe_index.r",
         "~/R/ageing/datasets/rheumatoid_arthritis/females/nn_gw.r",
         "~/R/ageing/datasets/rheumatoid_arthritis/females/yx_test.r")
#RAM
ram <- c("~/R/ageing/datasets/rheumatoid_arthritis/males/gse42861_ra/single_gse_gw_probe_index_male.r",
  "~/R/ageing/datasets/rheumatoid_arthritis/males/gse42861_ra/nn_yx_train_gw.r",
  "~/R/ageing/datasets/rheumatoid_arthritis/males/gse42861_ra/yx_test.r")
#ADF
adf <- c("~/R/ageing/datasets/alzheimers/females/gw_probe_index.r",
         "~/R/ageing/datasets/alzheimers/females/nn_yx_train_gw.r",
         "~/R/ageing/datasets/alzheimers/females/yx_test.r")
#ADM
adm <- c("~/R/ageing/datasets/alzheimers/males/probe_index.r",
         "~/R/ageing/datasets/alzheimers/males/nn_trained.r",
         "~/R/ageing/datasets/alzheimers/males/yx_test.r")
#NAF
naf <-c("~/R/ageing/datasets/nafld/females/probe_index.r",
        "~/R/ageing/datasets/nafld/females/nn_pi.r",
        "~/R/ageing/datasets/nafld/females/yx_test.r")
#NAM
nam <- c("~/R/ageing/datasets/nafld/males/probe_index_gw.r",
         "~/R/ageing/datasets/nafld/males/nn_gw.r",
         "~/R/ageing/datasets/nafld/males/yx_test.r")


filelist <- list(raf,ram,adf,adm,naf,nam)

source("~/R/ageing/functions/make_roc_object.r")
roc_object_list <- list()
i <- 1
for (files in filelist){
  print(files)
  roc_object_list[i]  <- list(make_roc_object(data = files[3], probes = files[1], model = files[2]))
  i = i + 1
}


rafp <- ggroc(roc_object_list[[1]]) +
  ggtitle("A - RA/Healthy Females \nValidation Set ROC") +
  geom_abline(intercept = 1, slope = 1, color = "red", linetype="dashed", size=0.3)  +
  theme(legend.position = "none", 
        plot.title = element_text(size = 8), text = element_text(size=8))

ramp <- ggroc(roc_object_list[[2]]) +
  ggtitle("D - RA/Healthy Males \nValidation Set ROC") +
  geom_abline(intercept = 1, slope = 1, color = "red", linetype="dashed", size=0.3)  +
  theme(legend.position = "none", 
        plot.title = element_text(size = 8), text = element_text(size=8))

adfp <- ggroc(roc_object_list[[3]]) +
  ggtitle("B - AD/Healthy Females \nValidation Set ROC") +
  geom_abline(intercept = 1, slope = 1, color = "red", linetype="dashed", size=0.3)  +
  theme(legend.position = "none", 
        plot.title = element_text(size = 8), text = element_text(size=8))

admp <- ggroc(roc_object_list[[4]]) +
  ggtitle("E - AD/Healthy Females \nValidation Set ROC") +
  geom_abline(intercept = 1, slope = 1, color = "red", linetype="dashed", size=0.3)  +
  theme(legend.position = "none", 
        plot.title = element_text(size = 8), text = element_text(size=8))

nafp <- ggroc(roc_object_list[[5]]) +
  ggtitle("C - NA/Healthy Females \nValidation Set ROC") +
  geom_abline(intercept = 1, slope = 1, color = "red", linetype="dashed", size=0.3) +
  theme(legend.position = "none", 
        plot.title = element_text(size = 8), text = element_text(size=8))

namp <- ggroc(roc_object_list[[6]]) +
  ggtitle("F - NA/Healthy Males \nValidation Set ROC") +
  geom_abline(intercept = 1, slope = 1, color = "red", linetype="dashed", size=0.3) +
  theme(legend.position = "none", 
        plot.title = element_text(size = 8), text = element_text(size=8))

#gridExtra::grid.arrange(rafp, adfp, nafp,
#                        ramp, admp, namp, 
#                        ncol = 3)

gggg <- arrangeGrob(rafp, adfp, nafp,
                     ramp, admp, namp, 
                     ncol = 3)
ggsave(filename = "~/R/ageing/datasets/Plot_data/roc_plots_plots.png",
       plot = gggg,
       device = png(),
       width = 160,
       height = 100,
       units = "mm",
       dpi = 320)
