#!/bin/sh

CURRENT_DIR=$(PWD)
cd "$(dirname "$0")"
./run.sh install --image serverimage --container SampleContainer
cd "$CURRENT_DIR"
