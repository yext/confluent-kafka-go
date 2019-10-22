#!/bin/sh
#
# This script can be used on either Linux or MacOS to build librdkafka and
# dependent static libraries.
#
# After running to completion, you can find all headers & libraries in the work
# directory.

set -e

RDKAFKA_URL=https://github.com/edenhill/librdkafka/archive/v1.2.1.tar.gz

OS=$(uname -s)
function _tar_xz() {
    if [ "$OS" == "Darwin" ]; then
        tar zxf "$@"
    else
        tar Jxf "$@"
    fi
}

# Create a temp directory to work in
BUILD=`echo ~/rdkafka-build`
mkdir $BUILD
echo "Work directory: $BUILD"

# Download Rdkafka
cd $BUILD
curl -LO $RDKAFKA_URL
tar zxf *.tar.gz
rm *.tar.gz
cd librdkafka*

##############################
# Delegates
##############################

export CPPFLAGS=-I$BUILD/include
export LDFLAGS=-L$BUILD/lib

echo CONFIGURE: zlib
curl -LO http://www.imagemagick.org/download/delegates/zlib-1.2.11.tar.xz
_tar_xz zlib*.xz && rm zlib*.xz && mv zlib* zlib && cd zlib
./configure --prefix=$BUILD --static
make install
cd ..

echo CONFIGURE: openssl
curl -LO https://www.openssl.org/source/openssl-1.1.1d.tar.gz
tar zxf openssl-* && cd openssl-*
./configure --prefix=$BUILD zlib --static darwin64-x86_64-cc
make -j 8 install
cd ..

echo CONFIGURE: zstd
curl -LO https://github.com/facebook/zstd/releases/download/v1.4.3/zstd-1.4.3.tar.gz
tar zxf zstd-* && cd zstd-*
make -j 8 install
cd ..


##############################
# Build librdkafka
##############################

./configure                       \
    --prefix=$BUILD               \
    --enable-ssl                  \
    --enable-zstd                 \
    --enable-lz4                  \
    --enable-static               \
    --source-deps-only            \
    --disable-shared              \
    --disable-dependency-tracking

make
make install
