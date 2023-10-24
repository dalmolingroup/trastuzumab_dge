########################################################
#                                                      #
#        Universidade Federal do Rio Grande do Sul     #
#                                                      #
#       Professor Patricia Klarmann Ziegelmann         #
#                                                      #
#         Meta-Analysis for Binary Outcomes            #
#                                                      #
########################################################

# ----------- DESCRIPTION -----------

# - We conducted a Meta-analysis to compare the treated (TRZ) and the control group.
# - Mean differences in the magnitude of gene expression changes
#  (Log2 fold-change [Log2FC]) were estimated using a random-effects models.
# - The analysis was conducted using the Metagen package.

## Load the necessary libraries to run this script
library(meta)
library(dplyr)

# Set up the database with the 3 studies in the same database
GSE91383 = read.table("results/GSE91383.csv", header = T, sep = ",")
GSE107385 = read.table("results/GSE107385.csv", header = T,sep = ",")
GSE116127 = read.table("results/GSE116127.csv", header = T,sep = ",")
GSE91383$study=rep("GSE91383",nrow(GSE91383))
GSE107385$study=rep("GSE107385",nrow(GSE107385))
GSE116127$study=rep("GSE116127",nrow(GSE116127))



GSE91383=relocate(GSE91383,study,hgnc_symbol,log2FoldChange,CI.L,CI.R)
GSE91383=GSE91383[,1:5]
GSE107385$log2FoldChange <- GSE107385$logFC
GSE107385=relocate(GSE107385,study,hgnc_symbol,log2FoldChange,CI.L,CI.R)
GSE107385=GSE107385[,1:5]
GSE116127=relocate(GSE116127,study,hgnc_symbol,log2FoldChange,CI.L,CI.R)
GSE116127=GSE116127[,1:5]

dados = rbind(GSE91383,GSE107385,GSE116127)
dados=arrange(dados,hgnc_symbol)
dados <- dados[!is.na(dados$hgnc_symbol),]
tabela=table(dados$hgnc_symbol)
write.csv2(tabela,"results/tabela_genes.csv")

##################################################################################
##Meta-analysis models considering DIFFERENT variations for each gene
mG1=metagen(TE=log2FoldChange,lower=CI.L, upper=CI.R,
            data=dados,
            method.tau="DL",
            sm="MD",
            studlab=study,
            fixed=FALSE,
            backtransf=FALSE,
            prediction=FALSE,
            subgroup=hgnc_symbol, ## to do a meta-analysis for each group
            tau.common = FALSE)   ## suposicao de variancias distintas
mG1

# when you look at the results below, see only the results
# of the meta-analysis of each gene
resultadoG1=data.frame(gene=mG1$subgroup.levels,
                       k=mG1$k.study.w,
                       MD=mG1$TE.random.w,
                       LI=mG1$TE.random.w-1.96*mG1$seTE.random.w,
                       LS=mG1$TE.random.w+1.96*mG1$seTE.random.w,
                       tau=mG1$tau.w,
                       tau2=mG1$tau2.w,
                       I2=round(mG1$I2.w*100,1),
                       pvalor=mG1$pval.random.w)
resultadoG1$significativo=ifelse(resultadoG1$pvalor<=0.05,1,0)
resultadoG1=arrange(resultadoG1,-significativo,-MD)
write.csv2(resultadoG1,"results/meta_analysis.csv")
