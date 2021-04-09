#!/bin/bash

DATE=`date -I | sed "s/-//g"`

echo $DATE
## copy the ccp dev dir
#mkdir -p CirComPara
#rsync -a /home/enrico/tools/circompara_3sum/src CirComPara/
#rsync -a /home/enrico/tools/circompara_3sum/circompara CirComPara/

mkdir -p circompara2
rsync -avPh /home/enrico/threesum_mount/tools/circompara2/src circompara2/
rsync -avPh /home/enrico/threesum_mount/tools/circompara2/circompara2 circompara2/

## build the docker container
docker build --build-arg INSTALL_THREADS=6 -t ccp2:dev$DATE .

## save the built docker image
docker save -o ccp2.dev$DATE.tar ccp2:dev$DATE

## deploy to threesum
rsync -a ccp2.dev$DATE.tar threesum:tools/dockers/

mkdir -p old_tars
mv ccp2.dev$DATE.tar old_tars
