# qemu-alpine

Docker image of QEMU compiled on Alpine Linux.

## Build

1. Update `Dockerfile` with latest QEMU and Alpine versions:
For example:
```
FROM alpine:3.4
ENV ALPINE_VERSION=3.4 QEMU_VERSION=2.7.0

ENV VERSION=${QEMU_VERSION}-${ALPINE_VERSION}
...
```

2. Update/generate any patches needed in `patches/${VERSION}` and configure them in `Dockerfile` to be applied.
For example:
```
...
COPY patches/${VERSION}/* /qemu-patches/
ENV PATCHES="fcntl.patch sigevent.patch sigrtmin.patch"
...
```

3. Given `${VERSION}` being current QEMU-Alpine version, build new image:
```
$ docker build -t qemu-alpine:${VERSION} .
```
