docker build --build-arg INSTALL_THREADS=6 -t circompara:1.1 .
docker run --rm -v /home/enrico/tools/circompara_docker:/data -it  circompara:1.1
