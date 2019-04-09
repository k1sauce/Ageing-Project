# Disease specific pathways shared across gender
# None for AD
dat <- read.csv('~/Downloads/pathways_rpa.csv')

dotplot(x=dat, x="ratio", color="neg_log_p")

counts <-c(255,223,205,234,205,234)
dat$Count <- counts


ggplot(dat, aes_string(x=dat$GeneRatio, y=dat$Description, size=dat$Count, color=dat$p.adjust)) +
  geom_point() +
  scale_color_continuous(low="blue", high="red", name = "-log(p)", guide=guide_colorbar(reverse=FALSE)) +
  ylab(NULL) + theme_dose(12) + scale_size(range=c(4, 5)) +
  xlab("Gene Ratio") + ggtitle("Disease Specific Enriched Pathways\nCommon between Sexs")


dat <- read.csv('~/Downloads/pathways_disease_specific.csv')

mdat <- melt(dat, c("pathway","disease_specific"))


ggplot(data=mdat, aes(x=mdat$pathway, y=mdat$value, fill=paste0(mdat$disease_specific,mdat$variable))) +
  geom_bar(stat="identity",position = position_dodge()) +
  theme_minimal() + ylab("-log P-value") + xlab("") +
  theme(axis.text.x = element_text(angle = 10, hjust=0.5, size = 10)) +
  scale_fill_discrete(name = "Strata", labels=c("NAFLD Female","NAFLD Male","RA Female","RA Male")) +
  ggtitle("Model Comparison - RA Females") + ylim(0,3)
  
