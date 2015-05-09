#!/bin/bash
rm -rf ./build/*
pushd build
cmake -DCMAKE_INSTALL_PREFIX=`kde4-config --prefix` ..
cpack ..
popd
