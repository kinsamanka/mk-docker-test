#!/bin/sh -ex

cd /usr/src/
tar xzf libm_fix.tar.gz 
cd machinekit-libm_fix/src
./autogen.sh
./configure \
	CC=arm-linux-gnueabihf-gcc \
	CXX=arm-linux-gnueabihf-g++ \
	--with-xenomai \
	--with-platform-beaglebone
make -j4
