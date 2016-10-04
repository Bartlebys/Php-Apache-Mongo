#!/bin/sh
#
# Usage
#
# If you call ./run.sh it will use the default.conf values.
#
# To proceed to install
#   ./run.sh install --image serverimage --container SampleContainer
#
# To delete the image
#   ./run.sh -d --image serverimage --container SampleContainer
#
# To preserve the image
#   ./run.sh -p --image serverimage --container SampleContainer

clear
CURRENT_DIR=$(PWD)
cd "$(dirname "$0")"
source default.conf

# Arguments parsing
while [[ $# -gt 0 ]]
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
    -o|--options-file)
    OPTIONS_FILE="$2"
    ;;
    *)
    #
    ;;
esac
shift
done

if [ -z ${OPTIONS_FILE+x} ];
    then
    echo "No options file"
    else
    echo "Using options file $OPTIONS_FILE"
    source $OPTIONS_FILE;
fi;

if [[ "$INSTALL" =~ ^YES ]];
    then
        # Force To destroy Image
        DESTROY_IMAGE="YES"
        XDEBUG="YES"
fi;


# Image name must be in lower case
if [ -z "IMAGE_NAME" ];
    then
        echo "IMAGE_NAME is undefined "
    else
       IMAGE_NAME=$(echo $IMAGE_NAME | awk '{print tolower($0);}' )
fi;


echo "";
echo OPTIONS_FILE: $OPTIONS_FILE
echo INSTALL: $INSTALL
echo CONTAINER_NAME: $CONTAINER_NAME
echo IMAGE_NAME: $IMAGE_NAME
echo DESTROY_IMAGE: $DESTROY_IMAGE
echo XDEBUG: $XDEBUG
echo APACHE_PORT: $APACHE_PORT
echo MONGO_DB_PORT: $MONGO_DB_PORT
echo POST_PROCESSING_SCRIPT: $POST_PROCESSING_SCRIPT

# Stop the container
echo "Stopping the container $CONTAINER_NAME"
docker stop $CONTAINER_NAME

# Delete the container
echo "Removing the container"
docker rm $CONTAINER_NAME

if [[ "$INSTALL" =~ ^YES ]];
  then
    echo "Pulling bartlebys/php-apache-mongo"
    # Let's pull the base Image
    docker pull bartlebys/php-apache-mongo
fi;

if [[ ("$INSTALL" =~ ^YES) || ("$DESTROY_IMAGE" =~ ^YES) ]];
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

        #################
        # ENABLE XDEBUG
        #################

         # Grab the Host IP
        HOST_IP=$(ifconfig en0 | grep inet | grep -v inet6 | awk '{print $2}')

        # Run the debuggable container
        # details available on https://github.com/Bartlebys/Php-Apache-Mongo/blob/master/README.md

        docker run  -e PHP_IDE_CONFIG="serverName=$SERVERNAME"\
                    -e XDEBUG_CONFIG="idekey=PHPSTORM"\
                    -e XDEBUG_CONFIG="remote_host=$HOST_IP"\
                    -p $MONGO_DB_PORT:27017 \
                    -p $APACHE_PORT:80\
                    -d --name $CONTAINER_NAME $IMAGE_NAME
else

    ###################
    # No XDEBUG Support
    ###################

    docker run -d  -p $APACHE_PORT:80  -p $MONGO_DB_PORT:27017 --name $CONTAINER_NAME $IMAGE_NAME
fi;

# Start mongod
echo "Starting the mongodb daemon in the container "
docker exec $CONTAINER_NAME service mongod start

# Run the post processing script
if [ -z ${POST_PROCESSING_SCRIPT+x} ];
    then
        echo ""
    else
        echo "Running post processing script $POST_PROCESSING_SCRIPT"
        $POST_PROCESSING_SCRIPT
fi;

# Open localhost in a browser on macOS
if [[ "$OSTYPE" =~ ^darwin ]];
    then open http://localhost:$APACHE_PORT/
fi;

cd "$CURRENT_DIR"
