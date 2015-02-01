FROM kinsamanka/docker-qemu-chroot:armv7l-base
MAINTAINER GP Orcullo <kinsamanka@gmail.com>

# configure apt
ADD	configure_apt.sh /opt/rootfs/tmp/
RUN	proot -r /opt/rootfs -q qemu-arm-static /tmp/configure_apt.sh

# install dependencies
ADD	install_dependencies.sh /opt/rootfs/tmp/
RUN	proot -r /opt/rootfs -q qemu-arm-static /tmp/install_dependencies.sh

# download MK
ADD	https://github.com/machinekit/machinekit/archive/master.tar.gz \
		/opt/rootfs/usr/src/

# build MK
ADD	build_mk.sh /opt/rootfs/tmp/
RUN     proot -b /dev/shm -r /opt/rootfs -q qemu-arm-static /tmp/build_mk.sh

# extract result when run from cmd line
CMD	tar cf - -C /opt/rootfs/usr/src .
