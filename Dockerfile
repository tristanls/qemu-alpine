FROM alpine:3.4
ENV ALPINE_VERSION=3.4 QEMU_VERSION=2.7.0

ENV VERSION=${QEMU_VERSION}-${ALPINE_VERSION}
ENV RM_DIRS="/etc/ssl /usr/include /usr/share/man /tmp/* /var/cache/apk/* /root/.gnupg /qemu-patches"
ENV DOWNLOAD_TOOLS="curl gnupg"
ENV BUILD_TOOLS="autoconf automake bison flex gcc glib-dev g++ libtool linux-headers make patch python"

COPY patches/${VERSION}/* /qemu-patches/
ENV PATCHES="fcntl.patch sigevent.patch sigrtmin.patch"

RUN apk add --no-cache ${DOWNLOAD_TOOLS} && \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys \
        # Michael Roth <flukshun@gmail.com>> see: http://wiki.qemu.org/SecurityProcess
        CEACC9E15534EBABB82D3FA03353C9CEF108B584 && \
    curl -o qemu-${QEMU_VERSION}.tar.bz2 -sSL http://wiki.qemu-project.org/download/qemu-${QEMU_VERSION}.tar.bz2 && \
    curl -o qemu-${QEMU_VERSION}.tar.bz2.sig -sSL http://wiki.qemu.org/download/qemu-${QEMU_VERSION}.tar.bz2.sig && \
    gpg qemu-${QEMU_VERSION}.tar.bz2.sig && \
    tar jxf qemu-${QEMU_VERSION}.tar.bz2 && \
    apk add --no-cache ${BUILD_TOOLS} && \
    cd qemu-${QEMU_VERSION} && \
    for file in ${PATCHES}; do patch -p1 < /qemu-patches/${file}; done && \
    mkdir build && \
    cd build && \
    ../configure && \
    NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && \
    make -j${NPROC}

RUN apk del ${DOWNLOAD_TOOLS} ${BUILD_TOOLS} && \
    rm -rf /qemu-${QEMU_VERSION}.tar.bz2 /qemu-${QEMU_VERSION}.tar.bz2.sig ${RM_DIRS} && \
    apk info -v
