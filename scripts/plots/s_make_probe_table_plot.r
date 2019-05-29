fblood <- read.csv("fblood.csv")
fblood <- as.character(fblood$X)
mblood <- read.csv("mblood.csv")
mblood <- as.character(mblood$X)
fbrain <- read.csv("fbrain.csv")
fbrain <- as.character(fbrain$X)
mbrain <- read.csv("mbrain.csv")
mbrain <- as.character(mbrain$X)
fliver <- read.csv("fliver.csv")
fliver <- as.character(fliver$X)
mliver <- read.csv("mliver.csv")
mliver <- as.character(mliver$X)

#make a table for frequency of common probe

probes <- list(fblood,mblood,fbrain,mbrain,fliver,mliver)

cc <- matrix(rep(0,36),ncol = 6)
i <- 1
for (set in probes){
  cc[,i] <- unlist(lapply(probes, function(probes) length(intersect(set,probes))))
  i = i + 1
}

colnames(cc) <- c("Female blood","Male blood","Female brain","Male brain","Female liver","Male liver")
rownames(cc) <- c("Female blood","Male blood","Female brain","Male brain","Female liver","Male liver")
write.csv(cc, file = "Probe_table.csv")

ptable <- read.csv("Probe_table.csv")


ptable <- reshape::melt(ptable)

ptable$X <- factor(ptable$X, levels = c("Male liver","Female liver","Male brain","Female brain","Male blood","Female blood"))


## plot data
ggplot(ptable, aes(variable, X)) +
  geom_tile(aes(fill = value)) + 
  geom_text(aes(label = round(value, 1)), cex = 10) +
  scale_fill_gradient(low = "light blue", high = "blue") +
  labs(x = "", y = "") +
  theme(text = element_text(size=30)) +
  scale_x_discrete(labels = c("Female blood","Male blood","Female brain","Male brain","Female liver","Male liver"))
