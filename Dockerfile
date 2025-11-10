FROM ubuntu:20.04

LABEL maintainer="Enrico Gaffo <enrico.gaffo@gmail.com>"

############################################################
# Software:		CirComPara2
# Software Version: 	develop
# Software Website: 	https://github.com/egaffo/circompara2
# Description: 	    	CirComPara2. Must copy the CirComPara2 repo dir in the
#			docker dir before building the container!
############################################################

ARG INSTALL_THREADS=4

ENV APP_NAME=circompara2
ENV VERSION=dev
ENV GIT=https://github.com/egaffo/$APP_NAME.git
ENV DEST=/$APP_NAME/
ENV PATH=$DEST/bin/:$DEST/src/utils/bash/:$PATH

## mind that this does not work if circompara2 is a symlink :(
#ADD circompara2 /circompara2
ADD packs /packs
ADD https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.12.1.zip /packs/

RUN apt-get update \
    && apt-get install -y \
	dirmngr \
	gnupg \
	apt-transport-https \
	ca-certificates \
	software-properties-common \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 && \
    add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/" && \
    apt-get update && \
    apt-get install -y \
	curl \
	default-jre \
	git \
	libcurl4-openssl-dev \
	libssl-dev \
	libxml2-dev \
	pigz \
	pkg-config \
	python2.7 \
	r-base-core \
	unzip \
	wget \
	zlib1g-dev \
	build-essential \
	bwidget \
	cargo \
	cython \
	freeglut3-dev \
	libcairo2-dev \
	libgdal-dev \
	libglu1-mesa-dev \
	libmagick++-dev \
	libncurses5-dev \
	libnlopt-dev \
	mesa-common-dev \
	pandoc \
	python-dev-is-python2 \
	python-is-python2 \
	python-numpy \
	time

RUN export CPUS=`grep -c ^processor /proc/cpuinfo` \
    && echo "Using $CPUS to install R packages" \
    && git clone $GIT \
    && cd $APP_NAME \
    && git switch $VERSION \
    && ln -s src/utils/bash/install_circompara \
    && ./install_circompara -j${INSTALL_THREADS} \
    && rm -rf .git \
    && rm -rf tools/*.gz \
    && rm -rf tools/*.zip \
    && rm -rf tools/*.bz2 \
    && rm -rf /var/lib/apt/lists/* \
    && sed -i "s_echo -e_echo_" src/sconstructs/collect_circrnas.py \
    && sed -i "s_echo -e_echo_" src/sconstructs/circrna_linear_expression.py

RUN tar -xf /packs/parallel-20200922-0.tar.bz2 -C /$APP_NAME/tools/parallel
    #&& cd /$APP_NAME/tools \
    #&& wget "https://anaconda.org/conda-forge/parallel/20200922/download/linux-64/parallel-20200922-0.tar.bz2" \
    #&& tar -xf parallel-20200922-0.tar.bz2 -C parallel

## install FastQC
RUN unzip -o -u -d /packs/ /packs/fastqc_v0.12.1.zip && \
	ln -sf /packs/FastQC/fastqc /circompara2/bin/

## install python2 pip. NB: get_pip.py has already been downloaded by install_circompara
RUN python2 /circompara2/tools/get-pip.py

## install CIRCexplorer2
RUN cd / && \
	git clone https://github.com/YangLab/CIRCexplorer2.git && \
	cd CIRCexplorer2 && \
	git checkout 2.3.8 && \
	sed -i "s_>_=_" requirements.txt && \
	echo "scipy==0.16" >> requirements.txt && \
	pip install -r requirements.txt && \
	python setup.py install

WORKDIR /data

#ENTRYPOINT ["/circompara2/circompara2"]
#build-essential \
#python2.7 \
#unzip \
#pkg-config \
#default-jre \
#r-base-core \
#libcurl4-openssl-dev \
#libxml2-dev \
#libssl-dev \
#git \
#wget \
#curl \
#pigz \
#python-is-python2 \
#python-dev-is-python2 \
#time \
#zlib1g-dev \
#python-pip \

