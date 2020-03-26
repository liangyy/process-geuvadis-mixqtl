library(optparse)

option_list <- list(
  make_option(c("-p", "--peer"), type="character", default=NULL,
              help="peer output X.csv",
              metavar="character"),
  make_option(c("-e", "--peer_meta"), type="character", default=NULL,
              help="the meta file (to tell the rows/individuals in X)",
              metavar="character"),
  make_option(c("-c", "--pca"), type="character", default=NULL,
              help="pca output from plink",
              metavar="character"),
  make_option(c("-d", "--pedigree"), type="character", default=NULL,
              help="pedigree data to know sex",
              metavar="character"),
  make_option(c("-o", "--output"), type="character", default=NULL,
              help="output covariate matrix",
              metavar="character")
)

opt_parser <- OptionParser(option_list=option_list)
opt <- parse_args(opt_parser)

library(data.table)
options(datatable.fread.datatable = FALSE)
library(dplyr)


# load peer
peer = fread(opt$peer, header = FALSE, sep = ',')
peer_meta = fread(cmd = paste0('zcat ', opt$peer_meta), header = TRUE, sep = '\t')
colnames(peer) = paste0('peerFactor', 1:ncol(peer))
peer$indiv = colnames(peer_meta)[-(1:4)]

# load pca
pca = fread(opt$pca, header = TRUE, sep = '\t')
pca = pca[, 1:6]  # take top 5 PCs

# load pedigree 
pedigree = fread(opt$pedigree, header = TRUE, sep = '\t')

# combine everything
covar_mat_by_indiv = pedigree %>% select(`Individual ID`, `Gender`) %>% 
  inner_join(peer, by = c('Individual ID' = 'indiv')) %>% 
  inner_join(pca, by = c('Individual ID' = '#IID'))
# covar_mat_by_indiv$Gender = covar_mat_by_indiv$Gender - 1  # code male as 0 and female as 1
covar_mat_ = covar_mat_by_indiv %>% select(-`Individual ID`)
rownames(covar_mat_) = covar_mat_by_indiv %>% pull(`Individual ID`)
covar_mat = t(covar_mat_)
ids = rownames(covar_mat)
rownames(covar_mat) = NULL
covar_mat = cbind(data.frame(ID = ids), covar_mat)

# save
gz1 <- gzfile(opt$output, "w")
write.table(covar_mat, gz1, col.names = TRUE, row.names = FALSE, quote = FALSE, sep = '\t')
close(gz1)


