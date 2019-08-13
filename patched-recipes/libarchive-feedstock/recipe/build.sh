#!/bin/bash

autoreconf -vfi

# Statically link bz2 and zstd
rm -f $PREFIX/lib/libbz2*${SHLIB_EXT}*
rm -f $PREFIX/lib/libzstd*${SHLIB_EXT}*

# Static library of libzstd requires this
export LIBS="${LIBS:-} -lpthread"

mkdir build-${HOST} && pushd build-${HOST}
${SRC_DIR}/configure --prefix=${PREFIX}  \
                     --without-zlib      \
                     --with-bz2lib       \
                     --with-iconv        \
                     --without-lz4       \
                     --without-lzma      \
                     --without-lzo2      \
                     --with-zstd         \
                     --without-cng       \
                     --without-openssl   \
                     --without-nettle    \
                     --without-xml2      \
                     --without-expat
make -j${CPU_COUNT} ${VERBOSE_AT}
make install-strip
popd

