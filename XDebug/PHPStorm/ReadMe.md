# Configuration

+ PhpStorm 2016.2.1
+ Build #PS-162.1889.1, built on August 23, 2016
+ You have perpetual fallback license for this version
+ JRE: 1.8.0_76-release-b216 x86_64
+ JVM: OpenJDK 64-Bit Server VM by JetBrains s.r.o

## macOS 

Sierra **10.12 (16A323)**

## Docker for mac 

Installed from the official [docker for mac](https://download.docker.com/mac/stable/Docker.dmg)

**Version 1.12.1** (build: 12133) 2d5b4d9c3daa089e3869e6355a47dd96dbf39856


# How to Run this sample

Go to the PHPStorm folder and run the shell script.

```Shell
./run.sh
```

After building the image (may take a few minutes) and running the container it should open a browser on http://localhost:8001/


# You can connect to the container

```Shell
bash -c "clear && docker exec -it DockerizedSample sh"
```

## In the container

XDebug is installed.

```shell
# php -m -c
[PHP Modules]
Core
ctype
curl
date
dom
ereg
fileinfo
filter
ftp
hash
iconv
json
libxml
mbstring
mcrypt
mongo
mysqlnd
openssl
pcre
PDO
pdo_sqlite
Phar
posix
readline
Reflection
session
SimpleXML
SPL
sqlite3
standard
sysvsem
tokenizer
xdebug
xml
xmlreader
xmlwriter
zlib

[Zend Modules]
Xdebug
```

The configuration seems ok.

```shell
# tail /usr/local/etc/php/conf.d/xdebug.ini

xdebug.idekey=PHPSTORM
xdebug.remote_host=172.17.0.1
xdebug.remote_enable=1
xdebug.remote_mode=req
xdebug.remote_port=9000
xdebug.remote_autostart=0
xdebug.remote_connect_back=0
zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20131226/xdebug.so
```

# The issue

Currently we are not able to use Xdebug on the Dockerized container.
