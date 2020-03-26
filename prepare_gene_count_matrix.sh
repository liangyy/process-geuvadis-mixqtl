downloadfile=GD660.GeneQuantCount.txt.gz
downloadfile2=GD462.GeneQuantRPKM.50FN.samplename.resk10.txt.gz
processfile=rmdup-GD660.GeneQuantCount.txt.gz
libsizefile=libsize-GD660.GeneQuantCount.txt.gz

# gene-level read count matrix and the matrix with a smaller set of genes (after more stringent QC)
if [[ ! -f $downloadfile ]]
then
  wget https://www.ebi.ac.uk/arrayexpress/files/E-GEUV-1/GD660.GeneQuantCount.txt.gz
  wget https://www.ebi.ac.uk/arrayexpress/files/E-GEUV-1/GD462.GeneQuantRPKM.50FN.samplename.resk10.txt.gz
fi

# remove duplicated individuals and generate library size vector
if [[ ! -f $processfile ]]
then
  Rscript util/clean_up_gene_count_matrix.R \
    --input $downloadfile \
    --input_gene $downloadfile2 \
    --out_mat $processfile \
    --out_lib $libsizefile
fi 