#!/bin/bash
SCRIPT=$(readlink -f $0)
ROOT_DIR=$(dirname $SCRIPT)/../
cd $ROOT_DIR

echo `pwd`
