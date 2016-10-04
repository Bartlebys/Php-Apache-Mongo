#!/bin/sh

CURRENT_DIR=$(PWD)
cd "$(dirname "$0")"

# We perform cleanup in case you run this script multiple times.
# Stop the container
echo "Stop "
docker stop DockerizedSample

# Delete the container
echo "Remove "
docker rm DockerizedSample

# Delete the image if necessary
docker rmi dockerizedsampleimage:latest

# Build the  image
echo "Building with the current source"
docker build -t dockerizedsampleimage:latest .

# Run the container
echo "Run container "

# Grab the Host IP
HOST_IP=$(ifconfig en0 | grep inet | grep -v inet6 | awk '{print $2}')

###############################
# Run the debuggable container
#
#   serverName?
#   in PHPStorm Use the name set in : Preferences/Languages & Frameworks/PHP/Servers
#
#   ideKey?
#   we do use commonly PHPSTORM but it should be consistent with your settings
#
###############################

docker run  -e PHP_IDE_CONFIG="serverName=DockerLocal"\
            -e XDEBUG_CONFIG="idekey=PHPSTORM"\
            -e XDEBUG_CONFIG="remote_host=$HOST_IP"\
            -p 27017:27017 \
            -p 8002:80\
            -d --name DockerizedSample dockerizedsampleimage

# Start mongod
echo "Start mongod "
docker exec DockerizedSample service mongod start

# Open localhost in a browser on macOS
if [[ "$OSTYPE" =~ ^darwin ]];
    then open http://localhost:8002/
fi;

cd "$CURRENT_DIR"