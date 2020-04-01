library(optparse)

option_list <- list(
  make_option(c("-i", "--input"), type="character", default=NULL,
              help="input",
              metavar="character"),
  make_option(c("-n", "--input_gene"), type="character", default=NULL,
              help="input with a smaller set of genes (only first column 
                which should be gene names is used)",
              metavar="character"),
  make_option(c("-o", "--out_mat"), type="character", default=NULL,
              help="output gene count matrix",
              metavar="character"),
  make_option(c("-u", "--out_lib"), type="character", default=NULL,
              help="output library size vector",
              metavar="character")
)

opt_parser <- OptionParser(option_list=option_list)
opt <- parse_args(opt_parser)

# for debugging
# opt = list(input = 'test.gz', out_mat = 'test_out_mat.gz', out_lib = 'test_out_lib.gz')

parse_indiv_from_sample = function(x) {
  unlist(lapply(strsplit(x, '\\.'), function(xx) {
    xx[1]
  }))
}
calc_size_factor = function(mat) {
  lmat = log(mat)
  lmat[mat == 0] = 0
  row_mean = rowMeans(lmat)
  diff = apply(lmat, 2, function(xx) {
    xx - row_mean
  })
  sf = exp(apply(diff, 2, median))
  sf
}


library(data.table)
options(datatable.fread.datatable = FALSE)
mat0 = fread(cmd = paste0('zcat < ', opt$input), header = T, sep = '\t')
mat_gene = fread(cmd = paste0('zcat < ', opt$input_gene, ' | cut -f 1'), header = T, sep = '\t')
# only keep genes in mat_gene
mat0 = mat0[mat0[, 1] %in% mat_gene[, 1], ]
sample_ids = colnames(mat0)[-(1:4)]
indiv_ids = parse_indiv_from_sample(sample_ids)
# remove duplicated individuals 
mat_rmdup = mat0[, c(rep(TRUE, 4), !duplicated(indiv_ids))]
new_sample_cols = indiv_ids[!duplicated(indiv_ids)]
# rearrange columns
mat_rmdup = mat_rmdup[, c(3, 4, 4, 1, 5 : ncol(mat_rmdup))]
mat_rmdup[, 2] = mat_rmdup[, 3] - 1
mat_rmdup[, 1] = paste0('chr', mat_rmdup[, 1])
colnames(mat_rmdup)[1:4] = c('#chr', 'start', 'end', 'gene_id')
colnames(mat_rmdup)[5:ncol(mat_rmdup)] = new_sample_cols
# save output matrix
gz1 <- gzfile(opt$out_mat, "w")
write.table(mat_rmdup, gz1, col.names = TRUE, row.names = FALSE, quote = FALSE, sep = '\t')
close(gz1)

# collect library size
lib_size = colSums(mat_rmdup[, -(1:4)])
size_factor = calc_size_factor(mat_rmdup[, -(1:4)])
df_lib = data.frame(indiv = names(lib_size), lib_size = lib_size, size_factor = size_factor)
rownames(df_lib) = NULL
# save output library size
gz1 <- gzfile(opt$out_lib, "w")
write.table(df_lib, gz1, col.names = TRUE, row.names = FALSE, quote = FALSE, sep = '\t')
close(gz1)
