#!/bin/sh

CURRENT_DIR=$(PWD)
cd "$(dirname "$0")"
./run.sh install
cd "$CURRENT_DIR"
