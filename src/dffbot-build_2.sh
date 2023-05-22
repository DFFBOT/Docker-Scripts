#!/bin/bash
set -e # exit on error

# install some packages
export LC_ALL=C
apt-get update
apt install -y python-dev python3 python3-dev python3-pip autoconf automake libtool-bin python3-bs4 libboost-all-dev # libclang-11.0-dev
python3 -m pip install networkx pydot pydotplus

cd ~/build
git clone https://github.com/DFFBOT/qemuafl qemuafl
cd ~/build/qemuafl
./configure --audio-drv-list= --disable-blobs --disable-bochs --disable-brlapi --disable-bsd-user --disable-bzip2 --disable-cap-ng --disable-cloop --disable-curl --disable-curses --disable-dmg --disable-fdt --disable-gcrypt --disable-glusterfs --disable-gnutls --disable-gtk --disable-guest-agent --disable-iconv --disable-libiscsi --disable-libnfs --disable-libssh --disable-libusb --disable-linux-aio --disable-live-block-migration --disable-lzo --disable-nettle --disable-numa --disable-opengl --disable-parallels --disable-plugins --disable-qcow1 --disable-qed --disable-rbd --disable-rdma --disable-replication --disable-sdl --disable-seccomp --disable-sheepdog --disable-smartcard --disable-snappy --disable-spice --disable-system --disable-tools --disable-tpm --disable-usb-redir --disable-vde --disable-vdi --disable-vhost-crypto --disable-vhost-kernel --disable-vhost-net --disable-vhost-scsi --disable-vhost-user --disable-vhost-vdpa --disable-vhost-vsock --disable-virglrenderer --disable-virtfs --disable-vnc --disable-vnc-jpeg --disable-vnc-png --disable-vnc-sasl --disable-vte --disable-vvfat --disable-xen --disable-xen-pci-passthrough --disable-xfsctl --target-list=x86_64-linux-user --without-default-devices --enable-pie --disable-strip --enable-debug --enable-debug-info --enable-debug-mutex --enable-debug-stack-usage --enable-debug-tcg --enable-qom-cast-debug --disable-werror
make -j$(nproc)

cd ~/build
export CXX=clang++
export CC=clang
git clone https://github.com/aflgo/aflgo.git aflgo
cd aflgo
make clean all
cp ~/build/qemuafl/build/qemu-x86_64 afl-qemu-trace
