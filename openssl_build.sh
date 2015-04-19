#!/bin/bash

. abi_settings.sh $1 $2 $3

pushd openssl

#make clean

./Configure \
  -fpic \
  no-shared \
  --prefix="${TOOLCHAIN_PREFIX}"  linux-generic32 || exit 1

make -j${NUMBER_OF_CORES} || exit 1

popd
