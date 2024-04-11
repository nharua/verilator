# How to build the docker 
docker buildx build --rm --tag verilator:versiontag --file .\Dockerfile .

# How to run
docker run -ti --rm --env DISPLAY=host.docker.internal:0 -v yourlocalDir:/workDir --hostname verilator verilator:versiontag /usr/bin/bash
