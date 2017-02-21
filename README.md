# Php-Apache-Mongo (with Dockerized XDebug support)

This Docker image is based on the Official `php-apache` image.
It offers a *Zero Config* fully *dockerized* development environment for macOS.
You just call one install script and you obtain a fully dockerized running PHP Development stack.

Feel free to contribute and [propose improvements](https://github.com/Bartlebys/Php-Apache-Mongo/issues).

## Featuring

- PHP 5.6 (7.X to come soon)
- MongoDB
- Apache
- Xdebug

# Includes a Fully functional PHPStorm Sample project


[XDebug/PHPStorm](XDebug/PHPStorm/)

![run](assets/run.png)


# How to install the PHPStorm sample?

Prerequisite: Download and install [docker for mac](https://download.docker.com/mac/stable/Docker.dmg)

1. Move to [XDebug/PHPStorm](XDebug/PHPStorm/)
2. Open your IDE and listen to XDebug.
3. run `./install.sh'
4. After building the image (may take a few minutes) and running the container it should open a browser on http://localhost:8002/
You will have a full PHP / APACHE / MONGODB container with XDEBUG enabled.


**You can run again with updated source by calling `./run.sh`**

![Config1](assets/config1.png)
![Config2](assets/config2.png)

## To proceed to install

```
./install.sh
```

# Run Usage

If you call `./run.sh` it will use the options set in `default.conf`.

## But you can run a different configuration

1. create a `configuration.conf` file
2. call `./run.sh -o configuration.conf`

## Sample configuration

```
######################################################
# This is the Run script configuration file
# It Defines the default value when calling ./run.sh
# You can run a specific configuration file with "-o file.conf"
#####################################################

# The name of the container That will be instantiated
CONTAINER_NAME=SampleContainer

# The name of the Docker Image That will be Created
# Must be lower cases (if not it will be by the run script)
IMAGE_NAME=sampledockerImage

# YES or NO if set to YES the image will be rebuilt
DESTROY_IMAGE=YES

# YES or NO if set to YES "XDEBUG" will be enabled
XDEBUG=YES

# YES or NO if set to YES it will pull the image from docker's hub
PULL_IMAGE=NO

# YES or NO if set to YES it will rebuild the Image.
INSTALL=NO

# 80, 8000, ... choose the apache port on your Host. You will access this instance on http://localhost:<PORT>/
APACHE_PORT=8002

# 27017, 27018, ... choose the mongodb port on your Host.
MONGO_DB_PORT=27018

# the PHPStorm Configuration Server name
SERVER_NAME=DockerLocal

# a script that will be called when the container is up
#POST_PROCESSING_SCRIPT=refreshSources.sh
```


# Alternative Manual Sequence

- Pull the base image `docker pull bartlebys/php-apache-mongo`
- Build the  image `docker build -t dockerizedsampleimage:latest .`
- Run the container

```

CURRENT_DIR=$(PWD)

# Grab the Host IP
HOST_IP=$(ifconfig en0 | grep inet | grep -v inet6 | awk '{print $2}')

mkdir $CURRENT_DIR/Mongo/db
mkdir $CURRENT_DIR/Mongo/configdb

docker run  -e PHP_IDE_CONFIG="serverName=DockerLocal"\
            -e XDEBUG_CONFIG="idekey=PHPSTORM"\
            -e XDEBUG_CONFIG="remote_host=$HOST_IP"\
            -p 27017:27017 \
            -p 8002:80\
            -v $CURRENT_DIR:/var/www/\
            -v $CURRENT_DIR/Mongo/db:/data/db\
            -v $CURRENT_DIR/Mongo/configdb:/data/configdb\
            -d --name DockerizedSample dockerizedsampleimage
            
```



# Validated with

+ PhpStorm 2016.2.1
+ Build #PS-162.1889.1, built on August 23, 2016
+ You have perpetual fallback license for this version
+ JRE: 1.8.0_76-release-b216 x86_64
+ JVM: OpenJDK 64-Bit Server VM by JetBrains s.r.o
+ macOS Sierra **10.12 (16A323)**
+ Docker for mac Installed from the official [docker for mac](https://download.docker.com/mac/stable/Docker.dmg) **Version 1.12.1** (build: 12133) 2d5b4d9c3daa089e3869e6355a47dd96dbf39856
