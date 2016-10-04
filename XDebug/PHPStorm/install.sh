#!/bin/sh

CURRENT_DIR=$(PWD)
cd "$(dirname "$0")"

./run.sh install --image serverImage --container SampleContainer

cd "$CURRENT_DIR"
