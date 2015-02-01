#!/bin/sh -ex

cd /usr/src/
tar xzf master.tar.gz
cd machinekit-master
./debian/configure -prx

debuild -us -uc -b -j4

# cleanup
cd ..
rm -r machinekit-master master.tar.gz /tmp/* 
