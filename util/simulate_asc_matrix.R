library(optparse)

option_list <- list(
  make_option(c("-t", "--trc"), type="character", default=NULL,
              help="TRC matrix as input to get gene list and individual list",
              metavar="character"),
  make_option(c("-o", "--out_prefix"), type="character", default=NULL,
              help="prefix of output: two ASC matrices",
              metavar="character")
)

opt_parser <- OptionParser(option_list=option_list)
opt <- parse_args(opt_parser)

set.seed(2020)
library(data.table)
options(datatable.fread.datatable = FALSE)

# opt = list(trc = '~/Desktop/tmp/GEUVADIS-mixqtl/geuvadis.total_count.bed.gz')


trc = fread(cmd = paste0('zcat < ', opt$trc), header = TRUE, sep = '\t')
gene_list = trc$gene_id
count = as.matrix(trc[, -(1:4)])
indiv_list = colnames(trc)[-(1:4)]

sim_asc = function(gene_list, indiv_list, count_mat, frac = 0.2) {
  ngene = length(gene_list)
  nindiv = length(indiv_list)
  asc_mat = matrix(
    rpois(ngene * nindiv, lambda = count_mat * frac), 
    nrow = ngene,
    ncol = nindiv
  )
  asc_mat[asc_mat > count_mat] = 0
  asc_df = as.data.frame(asc_mat)
  colnames(asc_df) = indiv_list
  asc_df = cbind(gene_list, asc_df)
  asc_df
}

asc1_df = sim_asc(gene_list, indiv_list, count)
asc2_df = sim_asc(gene_list, indiv_list, count)

# save output library size
gz1 <- gzfile(paste0(opt$out_prefix, '.h1.tsv.gz'), "w")
write.table(asc1_df, gz1, col.names = TRUE, row.names = FALSE, quote = FALSE, sep = '\t')
close(gz1)
gz1 <- gzfile(paste0(opt$out_prefix, '.h2.tsv.gz'), "w")
write.table(asc2_df, gz1, col.names = TRUE, row.names = FALSE, quote = FALSE, sep = '\t')
close(gz1)
