# process-geuvadis-mixqtl

Repository to process GEUVADIS data for mixQTL example

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
