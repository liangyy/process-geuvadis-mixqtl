library(optparse)

option_list <- list(
    make_option(c("-i", "--input"), type="character", default=NULL,
                help="input count matrix",
                metavar="character"),
    make_option(c("-n", "--input_lib"), type="character", default=NULL,
                help="input library size vector",
                metavar="character"),
    make_option(c("-o", "--output"), type="character", default=NULL,
                help="output (peer input csv)",
                metavar="character")
)

opt_parser <- OptionParser(option_list=option_list)
opt <- parse_args(opt_parser)


library(data.table)
options(datatable.fread.datatable = FALSE)

## each entry is log(TRC / 2)
mat0 = fread(cmd = paste0('zcat < ', opt$input), header = TRUE, sep = '\t')
mat = mat0[, -(1:4)]  # remove the first 4 columns which are not counts
trc = mat  # keep a record
lib0 = read.table(opt$input_lib, header = TRUE, sep = '\t', stringsAsFactors = FALSE)
lib0 = lib0[match(colnames(mat), lib0$indiv), ]  # so that they have the same order in individuals FOR SURE
mat = sweep(mat, 2, lib0$lib_size, FUN = '/')
mat = log(mat / 2)
mat[trc == 0] = NA

## Impute missing cells as suggested in paper
mat_imp = impute::impute.knn(as.matrix(mat))

## write CSV for PEER run
write.table(t(as.matrix(mat_imp$data)), opt$output, row = F, col = F, quo = F, sep = ',')
