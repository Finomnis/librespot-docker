ARG LIBRESPOT_VERSION="0.3.0"
ARG DEBIAN_VERSION="stretch"

###################################
# Build librespot
#
FROM debian:$DEBIAN_VERSION

RUN dpkg --add-architecture arm64
RUN dpkg --add-architecture armhf
RUN dpkg --add-architecture armel
RUN apt-get update

RUN apt-get install -y curl git build-essential crossbuild-essential-arm64 crossbuild-essential-armel crossbuild-essential-armhf pkg-config
RUN apt-get install -y libasound2-dev libasound2-dev:arm64 libasound2-dev:armel libasound2-dev:armhf

ARG LIBRESPOT_VERSION

RUN git clone --branch v$LIBRESPOT_VERSION --depth 1 https://github.com/librespot-org/librespot.git /src
WORKDIR /src

COPY install.sh /opt/install.sh
RUN /opt/install.sh
