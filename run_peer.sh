# ARGS1: target dir

targetdir=$1
nowdir=`pwd`
inputmat=rmdup-GD660.GeneQuantCount.txt.gz
inputlib=libsize-GD660.GeneQuantCount.txt.gz
matcsv=peer_input_csv-GD660.GeneQuantCount.csv

if [[ ! -d $targetdir ]]
then
  mkdir $targetdir
fi
cd $targetdir

# prepare matrix as csv
if [[ ! -f $matcsv ]]
then
  Rscript $nowdir/util/prepare_peer_csv.R \
    --input $inputmat \
    --input_lib $inputlib \
    --output $matcsv
fi
