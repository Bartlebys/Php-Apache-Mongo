#!/bin/sh
#
# Usage
#
# To proceed to install
#   ./run.sh install --image serverImage --container SampleContainer
#
# To delete the image
#   ./run.sh -d --image serverImage --container SampleContainer
#
# To preserve the image
#   ./run.sh -p --image serverImage --container SampleContainer

# Default values
CONTAINER_NAME=SampleContainer
IMAGE_NAME=serverImage
DESTROY_IMAGE=YES # YES or NO
XDEBUG=NO # YES or NO
INSTALL=NO # YES or NO
APACHE_PORT=8002

# Arguments parsing
while [[ $# -gt 1 ]]
do
key="$1"
case $key in
    install|installation)
    INSTALL="YES"
    shift
    ;;
    -d|--destroy)
    DESTROY_IMAGE="YES"
    shift
    ;;
    -p|--preserve)
    DESTROY_IMAGE="NO"
    shift
    ;;
    -x|--xdebug)
    XDEBUG="YES"
    shift
    ;;
    -c|--container)
    CONTAINER_NAME="$2"
    ;;
    -i|--image)
    IMAGE_NAME="$2"
    ;;
    *)
    #
    ;;
esac
shift
done


CURRENT_DIR=$(PWD)
cd "$(dirname "$0")"


if [[ "$INSTALL" =~ ^YES ]];
    then
        echo "Pulling bartlebys/php-apache-mongo"
        DESTROY_IMAGE="YES"
        XDEBUG="YES"
        # Let's pull the base Image
        docker pull bartlebys/php-apache-mongo
fi;

echo "";
echo CONTAINER_NAME: ${CONTAINER_NAME}
echo IMAGE_NAME: ${IMAGE_NAME}
echo DESTROY_IMAGE: ${DESTROY_IMAGE}
echo XDEBUG: ${XDEBUG}


# Stop the container
echo "Stopping the container $CONTAINER_NAME"
docker stop $CONTAINER_NAME

# Delete the container
echo "Removing the container"
docker rm $CONTAINER_NAME


if [[ "$DESTROY_IMAGE" =~ ^YES ]];

    then
        # Delete the image if necessary
        docker rmi $IMAGE_NAME:latest

        # Build the youdubserver image
        echo "Building the image $IMAGE_NAME with the current sources"
        docker build -t $IMAGE_NAME:latest .

fi;

# Run YouDubApi container
echo "Running the container $CONTAINER_NAME"

if [[ "$XDEBUG" =~ ^YES ]];
    then
         # Grab the Host IP
        HOST_IP=$(ifconfig en0 | grep inet | grep -v inet6 | awk '{print $2}')

        # Run the debuggable container
        # details available on https://github.com/Bartlebys/Php-Apache-Mongo/blob/master/README.md

        docker run  -e PHP_IDE_CONFIG="serverName=DockerLocal"\
                    -e XDEBUG_CONFIG="idekey=PHPSTORM"\
                    -e XDEBUG_CONFIG="remote_host=$HOST_IP"\
                    -p 27017:27017 \
                    -p APACHE_PORT:80\
                    -d --name $CONTAINER_NAME $IMAGE_NAME
else
    # No Xdebug Support
    docker run -d  -p APACHE_PORT:80  -p 27017:27017 --name $CONTAINER_NAME $IMAGE_NAME
fi;

# Start mongod
echo "Starting the mongodb daemon in the container "
docker exec $CONTAINER_NAME service mongod start

# Open localhost in a browser on macOS
if [[ "$OSTYPE" =~ ^darwin ]];
    then open http://localhost:$APACHE_PORT/
fi;

cd "$CURRENT_DIR"
