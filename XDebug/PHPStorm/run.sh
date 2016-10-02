#!/bin/sh

# Stop the container
echo "Stop "
docker stop DockerizedSample

# Delete the container
echo "Remove "
docker rm DockerizedSample

# Delete the image if necessary
docker rmi dockerizedsampleimage:latest

# Build the youdubserver image
echo "Building with the current source"
docker build -t dockerizedsampleimage:latest .

# Run DockerizedSample container
echo "Run container "

# Run the container once.
# then grab the IP of the HOST in the container
# stop and relaunch with the good IP
docker run  -d --name DockerizedSample dockerizedsampleimage
HOST_IN_CONTAINER_IP=$(docker exec DockerizedSample /sbin/ip route|awk '/default/ { print $3 }')
docker stop DockerizedSample
docker rm DockerizedSample

# Run the debuggable container
docker run  -e PHP_IDE_CONFIG="serverName=Dockerized"\
            -e XDEBUG_CONFIG="remote_host=$HOST_IN_CONTAINER_IP"\
            -p 27017:27017 \
            -p 8001:80\
            -d --name DockerizedSample dockerizedsampleimage\

# Start mongod
echo "Start mongod "
docker exec DockerizedSample service mongod start

echo "IP in Docker Host"
echo "$HOST_IN_CONTAINER_IP"

echo "Local IP"
ipconfig getifaddr en0

# Open localhost in a browser on macOS
if [[ "$OSTYPE" =~ ^darwin ]];
    then open http://localhost:8001/
fi;