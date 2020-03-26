# ARGS1: target dir
# ARGS2: path to peer tool (absolute path please)

# PEER parameter
nfactor=20
# END

peertoolpath=$2
targetdir=$1
nowdir=`pwd`
inputmat=rmdup-GD660.GeneQuantCount.txt.gz
inputlib=libsize-GD660.GeneQuantCount.txt.gz
matcsv=peer_input_csv-GD660.GeneQuantCount.csv
peerdir=peer

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
echo "finished prepare CSV"

# the actual peer run
if [[ ! -d $peerdir ]]
then
  mkdir $peerdir
fi
if [[ ! -f $peerdir/X.csv ]]
then
  echo "START" > $peerdir/peer.log
  stdbuf -oL $peertoolpath -f $matcsv -n $nfactor -i 1000 -o $peerdir --e_pb 10 --e_pa 0.1 --a_pb 0.01 --a_pa 0.001 |
  while IFS= read -r line
  do
    echo "$line" >> $peerdir/peer.log
  done
fi

