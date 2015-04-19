#!/bin/bash

. abi_settings.sh $1 $2 $3

pushd rtmpdump

NDK=$ANDROID_NDK
SYSROOT=$NDK_SYSROOT/
TOOLCHAIN=$TOOLCHAIN_PREFIX
OPENSSL_DIR=$BASEDIR/openssl/

echo __SYSROOT__$SYSROOT

# Note: Change the above variables for your system.
function build_one
{
	set -e
    make clean
    ln -s ${SYSROOT}usr/lib/crtbegin_so.o
    ln -s ${SYSROOT}usr/lib/crtend_so.o
    
    export XLDFLAGS="$ADDI_LDFLAGS -L${OPENSSL_DIR}libs/armeabi -L${SYSROOT}usr/lib "
    export CROSS_COMPILE=$TOOLCHAIN/bin/arm-linux-androideabi-
    export XCFLAGS="${ADDI_CFLAGS} -I${OPENSSL_DIR}include -isysroot ${SYSROOT}"
    export INC="-I${SYSROOT}"
    make THREADLIB_posix= THREADLIB_darwin= CRYPTO= prefix=\"${PREFIX}\" SHARED= OPT= install
}
CPU=arm
PREFIX=$TOOLCHAIN_PREFIX
ADDI_CFLAGS="-marm"
build_one

#./configure \
#  --with-pic \
#  --with-sysroot="$NDK_SYSROOT" \
#  --host="$NDK_TOOLCHAIN_ABI" \
#  --enable-static \
#  --disable-shared \
#  --prefix="${TOOLCHAIN_PREFIX}" \
#  --enable-arm-neon="$ARM_NEON" \
#  --disable-shared || exit 1

#make -j${NUMBER_OF_CORES} install || exit 1

popd
