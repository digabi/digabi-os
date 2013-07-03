Kernel for Digabi live
======================================

mkdir digabi-kernel
cd digabi-kernel
wget https://www.kernel.org/pub/linux/kernel/v3.x/linux-3.2.48.tar.xz
wget https://grsecurity.net/stable/grsecurity-2.9.1-3.2.48-201306302051.patch

git clone git://git.code.sf.net/p/aufs/aufs3-standalone aufs3-standalone
cd aufs3-standalone
git checkout -b aufs3.2 origin/aufs3.2

tar -xvJf linux-3.2.48.tar.xz
cd linux-3.2.48

patch -p1 < ../aufs3-standalone/aufs3-kbuild.patch
patch -p1 < ../aufs3-standalone/aufs3-base.patch
patch -p1 < ../aufs3-standalone/aufs3-proc_map.patch
patch -p1 < ../aufs3-standalone/aufs3-standalone.patch

patch -p1 < ../grsecurity-2.9.1-3.2.48-201306302051.patch

## Configuring Linux Kernel
    apt-get install build-essential kernel-package libncurses5-dev
    make menuconfig


### Add support for AUFS
    CONFIG_AUFS_FS=m


### Enable grsecurity
