# ARGS1: target directory

targetdir=$1
nowdir=`pwd`
trcfile=geuvadis.total_count.bed.gz
ascprefix=geuvadis.asc

if [[ ! -d $targetdir ]]
then
  mkdir $targetdir
fi
cd $targetdir

if [[ ! -f $acsprefix.h1.tsv.gz ]]
then
  Rscript $nowdir/util/simulate_asc_matrix.R \
    --trc $trcfile \
    --out_prefix $ascprefix
fi
