library(biomaRt)
ensembl = useMart("ensembl",dataset="hsapiens_gene_ensembl")
listFilters(ensembl)
listAttributes(ensembl)

ptprn2 <- getBM(attributes = c("chromosome_name","start_position",
                     "end_position","external_gene_name","p_value","strand"),filters = "ensembl_gene_id", values = "ENSG00000155093", mart = ensembl)
require(devtools)
install_version("ggplot2", version = "1.0.0")

biocLite("TxDb.Hsapiens.UCSC.hg38.knownGene")
biocLite("ggbio")
biocLite("biovisBase")

p1 <- autoplot(txdb, which = genesymbol["ALDOA"], names.expr = "tx_name:::gene_id")
p2 <- autoplot(txdb, which = genesymbol["ALDOA"], stat = "reduce", color = "brown",
               fill = "brown")
tracks(full = p1, reduce = p2, heights = c(5, 1)) + ylab("")

library(TxDb.Hsapiens.UCSC.hg19.knownGene)
library(ggbio)
data(genesymbol, package = "biovizBase")
txdb <- TxDb.Hsapiens.UCSC.hg19.knownGene
model <- exonsBy(txdb, by = "tx")
model17 <- subsetByOverlaps(model, genesymbol["RBM17"])
exons <- exons(txdb)
exon17 <- subsetByOverlaps(exons, genesymbol["RBM17"])
## reduce to make sure there is no overlap
## just for example
exon.new <- reduce(exon17)
## suppose
values(exon.new)$sample1 <- rnorm(length(exon.new), 10, 3)
values(exon.new)$sample2 <- rnorm(length(exon.new), 10, 10)
values(exon.new)$score <- rnorm(length(exon.new))
values(exon.new)$significant <- sample(c(TRUE,FALSE), size = length(exon.new),replace = TRUE)
## data ready
exon.new

p17 <- ggbio::autoplot(txdb, genesymbol["RBM17"])
plotRangesLinkedToData(exon.new, stat.y = c("sample1", "sample2"), annotation = list(p17))


biocLite("Sushi")
library("Sushi")

Sushi_data = data(package = 'Sushi')
data(list = Sushi_data$results[,3])
head(Sushi_genes.bed)
chrom = "chr15"
chromstart = 72965000
chromend = 72990000
pg = plotGenes(Sushi_genes.bed,chrom,chromstart,chromend ,
                 types=Sushi_genes.bed$type,maxrows=1,bheight=0.2,
                 plotgenetype="arrow",bentline=FALSE,
                 labeloffset=.4,fontsize=1.2,arrowlength = 0.025,
                 labeltext=TRUE)

pg = plotGenes(Sushi_transcripts.bed,chrom,chromstart,chromend ,
               types = Sushi_transcripts.bed$type,
               colorby=log10(Sushi_transcripts.bed$score+0.001),
               colorbycol= SushiColors(5),colorbyrange=c(0,1.0),
               labeltext=TRUE,maxrows=50,height=0.4,plotgenetype="box")
labelgenome( chrom, chromstart,chromend,n=3,scale="Mb")
