FROM ubuntu:20.04
#FROM ubuntu:16.04

LABEL maintainer="Enrico Gaffo <enrico.gaffo@gmail.com>"

############################################################
# Software: 		CirComPara2
# Software Version: 	develop
# Software Website: 	https://github.com/egaffo/circompara2
# Description: 		CirComPara2. Must copy the CirComPara2 repo dir in the
#			docker dir before building the container!
############################################################

ARG INSTALL_THREADS=4

ENV APP_NAME=circompara2
#ENV VERSION=feature/ccp-counts
#ENV GIT=https://github.com/egaffo/circompara2 ## can't do it because of login issue
ENV DEST=/software/applications/$APP_NAME/
ENV PATH=$DEST/$VERSION/:$DEST/$VERSION/scripts/:$PATH
ENV PACKS /packs

## mind that this does not work if circompara2 is a symlink :(
ADD circompara2 /circompara2 

RUN apt-get update && \
    apt-get install -y dirmngr gnupg apt-transport-https ca-certificates software-properties-common && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 && \
    add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/" && \
    apt-get update && \
    apt-get install -y \
	python2.7 \
	#python-numpy \
	#zlib1g-dev \
	unzip \
	pkg-config \
	#libncurses5-dev \
	default-jre \
	r-base-core \
	libcurl4-openssl-dev \
	libxml2-dev \
	libssl-dev \
	#libcairo2-dev \
	#pandoc \
	#cargo \
	#libgdal-dev \
	git \
	wget \
	#libnlopt-dev \
	curl \
	#mesa-common-dev \
	#libglu1-mesa-dev \
	#freeglut3-dev \
	#bwidget \
	#libmagick++-dev \
	pigz \
        python-is-python2 \
        python-dev-is-python2 \
	#cython \
    && export CPUS=`grep -c ^processor /proc/cpuinfo` \
    && echo "Using $CPUS to install R packages" \
    && cd $APP_NAME \
    && ln -s src/utils/bash/install_circompara \
    && ./install_circompara -j${INSTALL_THREADS} \
    && rm -rf .git \
    && rm -rf tools/*.gz \
    && rm -rf tools/*.zip \
    && rm -rf tools/*.bz2 \
    && rm -rf /var/lib/apt/lists/* \
    && sed -i "s_echo -e_echo_" src/sconstructs/collect_circrnas.py \
    && sed -i "s_echo -e_echo_" src/sconstructs/circrna_linear_expression.py \
    && cd ../ 

WORKDIR /data

ENTRYPOINT ["/circompara2/circompara2"]
