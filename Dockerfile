FROM debian:jessie
MAINTAINER GP Orcullo <kinsamanka@gmail.com>

ENV TERM dumb
ENV ROOTFS /opt/rootfs

# apt config:  silence warnings and set defaults
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true
ENV LC_ALL C 
ENV LANGUAGE C
ENV LANG C

# container OS
RUN echo 'APT::Install-Recommends "0";\nAPT::Install-Suggests "0";' > \
            /etc/apt/apt.conf.d/01norecommend
# proot OS
RUN mkdir -p ${ROOTFS}/etc/apt/apt.conf.d && \
    echo 'APT::Install-Recommends "0";\nAPT::Install-Suggests "0";' > \
            ${ROOTFS}/etc/apt/apt.conf.d/01norecommend

# install required dependencies
RUN apt-get update && \
    apt-get -y install \
        debootstrap \
        proot 

# patch debootstrap as /proc cannot be mounted under proot
RUN sed -i 's/in_target mount -t proc/#in_target mount -t proc/g' \
        /usr/share/debootstrap/functions

# for qemu in proot
RUN apt-get -y install \
        qemu-user-static
ADD proot-helper /bin/

ENV SUITE jessie
ENV ARCH  amd64
#
# [Leave surrounding comments to eliminate merge conflicts]
#

# build under ${ROOTFS}
RUN mkdir -p ${ROOTFS} && \
    debootstrap --foreign --no-check-gpg --include=ca-certificates \
        --arch=${ARCH} ${SUITE} ${ROOTFS} http://httpredir.debian.org/debian
RUN proot -b /dev/pts -r ${ROOTFS} /debootstrap/debootstrap --second-stage --verbose
