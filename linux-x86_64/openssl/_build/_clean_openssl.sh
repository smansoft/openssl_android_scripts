#!/bin/bash

BUILD_DIR="./_build";

CURR_DIR=$(pwd);

BUILD_DIR_A="$CURR_DIR/$BUILD_DIR";

if [ -d $BUILD_DIR_A ]; then
    rm -rf $BUILD_DIR_A;
fi;

exit 0;
