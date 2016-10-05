#!/bin/sh

CURRENT_DIR=$(PWD)
cd "$(dirname "$0")"
./run.sh -o install.conf
cd "$CURRENT_DIR"
