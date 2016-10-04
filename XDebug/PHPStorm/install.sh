#!/bin/sh

CURRENT_DIR=$(PWD)
cd "$(dirname "$0")"

# Let's pull the base Image
docker pull bartlebys/php-apache-mongo

./run.sh

cd "$CURRENT_DIR"