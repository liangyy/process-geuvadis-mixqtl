# process-geuvadis-mixqtl

Repository to process GEUVADIS data for mixQTL example

# TL;DR Example data download link

[Download from here](https://uchicago.box.com/s/5wf1b13h08qlu7lzkiswed7ndm215tll).

Example data includes:

* **Phased genotype**: `GEUVADIS.chr22.PH1PH2_465.IMPFRQFILT_BIALLELIC_PH.annotv2.genotypes.vcf.gz`.
* Total count matrix (in BED format): `geuvadis.total_count.bed.gz` (3th column is TSS (base-1) and 5th ~ (5+n)th columns are counts in n individuals).
* **Allele-specific count matrix**: `geuvadis.asc.h[1,2].tsv.gz`, gene x individual matrix with 1st row and column being gene ID and individual ID. There are two of them labeled with `h1` and `h2` indicating the two gene-level allele-specific counts. 
* **Library size**: `geuvadis.library_size.tsv.gz` with individual ID (1st column), library size (2nd column), and size factor by DESeq (3rd column).
* **Covariate matrix**: `geuvadis.covariate.txt.gz`, covariate x individual matrix with 1st row and column being covariate name and individual ID.
* **Proceed genotype in parquet**: `tempo-GEUVADIS.chr22.PH1PH2_465.IMPFRQFILT_BIALLELIC_PH.annotv2.genotypes.hap[1-2].parquet`. SNP x individual matrix where row name is SNP ID (naming convention `snp_[chromosome]_[position]`) and column name is individual ID.

# Desired outputs

* Gene-level total count matrix
* Library size vector
* Genotype data
* Covariate matrix:
    * run PEER
    * run PCA
* Allele-specific count matrix

# Run

Prepare data.

```
bash download_genotype.sh
bash prepare_gene_count_matrix.sh
bash run_peer.sh  # it is time consuming. Run qsub/peer.qsub on CRI@UChicago instead
bash prepare_covariate.sh
```

Run py-mixqtl using example data.

```
jupyter nbconvert \
  --to notebook \
  --inplace \
  --execute \
  --ExecutePreprocessor.timeout=0 \
  test_run/mixqtl_run.ipynb
```

Extra: compare py-mixqtl and r-mixqtl on one gene.

```
jupyter nbconvert \
  --to notebook \
  --inplace \
  --execute \
  --ExecutePreprocessor.timeout=0 \
  test_run/test_r_mixqtl.ipynb
```
