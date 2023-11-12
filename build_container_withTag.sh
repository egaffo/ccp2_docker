#!/bin/bash

#DATE=`date -I | sed "s/-//g"`

if [ -z $1 ]; then

    echo "No arguments supplied. Please, input the version tag. E.g. ./build_container_withTag.sh v0.1"
    echo "Aborting"

else

    echo "Building Docker image circompara2:$1, continue? [No (default); Yes]"
    read input

    if [[ $input == "Yes" ]]; then

	echo "Start building" `date`

	## copy the ccp dev dir

        # mkdir -p circompara2
        # rsync -avPh /home/enrico/threesum_mount/tools/circompara2/src circompara2/
        # rsync -avPh /home/enrico/threesum_mount/tools/circompara2/circompara2 circompara2/

        ## build the docker container  --no-cache
        docker build --build-arg INSTALL_THREADS=4 -t circompara2:$1 .

        ## save the built docker image
        docker save -o circompara2$1.tar circompara2:$1

        ## deploy to threesum
        rsync -a circompara2$1.tar threesum:tools/dockers/

        mkdir -p old_tars
        mv circompara2$1.tar old_tars

    else

        echo "Aborting"

    fi

fi

echo "End building" `date`
