# here we only use chr22
# we'd prefer pgen format in plink2 rather than vcf.gz 
# so that the genotype is converted

plink2binary=/gpfs/data/im-lab/nas40t2/yanyul/softwares/plink2
genofile=GEUVADIS.chr22.PH1PH2_465.IMPFRQFILT_BIALLELIC_PH.annotv2.genotypes.vcf.gz
plinkfilepre=GEUVADIS.chr22.PH1PH2_465.IMPFRQFILT_BIALLELIC_PH.annotv2.genotypes
pedigreefile=20130606_g1k.ped

if [[ ! -f $genofile ]]
then
  wget https://www.ebi.ac.uk/arrayexpress/files/E-GEUV-1/GEUVADIS.chr22.PH1PH2_465.IMPFRQFILT_BIALLELIC_PH.annotv2.genotypes.vcf.gz
fi


if [[ ! -f $plinkfilepre.pgen ]]
then
  # I have to do some ugly fixes so that vcf get read by plink2
  zcat $genofile | sed 's/ /+/g' | gzip > tempo-$genofile
  $plink2binary --vcf tempo-$genofile --make-pgen --out $plinkfilepre
fi

if [[ ! -f $plinkfilepre.eigenval ]]
then
  $plink2binary --pfile $plinkfilepre --pca --out $plinkfilepre
fi

if [[ ! -f $pedigreefile ]]
then
  wget ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/working/20130606_sample_info/20130606_g1k.ped
fi
