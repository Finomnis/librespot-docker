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

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin/:${PATH}"
RUN rustup target add aarch64-unknown-linux-gnu
RUN rustup target add arm-unknown-linux-gnueabi
RUN rustup target add arm-unknown-linux-gnueabihf

RUN mkdir /.cargo && \
    echo '[target.aarch64-unknown-linux-gnu]\nlinker = "aarch64-linux-gnu-gcc"' > /.cargo/config && \
    echo '[target.arm-unknown-linux-gnueabihf]\nlinker = "arm-linux-gnueabihf-gcc"' >> /.cargo/config && \
    echo '[target.arm-unknown-linux-gnueabi]\nlinker = "arm-linux-gnueabi-gcc"' >> /.cargo/config && \
    echo '[target.mipsel-unknown-linux-gnu]\nlinker = "mipsel-linux-gnu-gcc"' >> /.cargo/config

ENV CARGO_TARGET_DIR=/build
ENV CARGO_HOME=/build/cache
ENV PKG_CONFIG_ALLOW_CROSS=1
ENV PKG_CONFIG_PATH_aarch64_unknown_linux_gnu=/usr/lib/aarch64-linux-gnu/pkgconfig/
ENV PKG_CONFIG_PATH_arm_unknown_linux_gnueabihf=/usr/lib/arm-linux-gnueabihf/pkgconfig/
ENV PKG_CONFIG_PATH_arm_unknown_linux_gnueabi=/usr/lib/arm-linux-gnueabi/pkgconfig/

ARG LIBRESPOT_VERSION

RUN git clone --branch v$LIBRESPOT_VERSION --depth 1 https://github.com/librespot-org/librespot.git /src
WORKDIR /src

RUN cargo build --release --target aarch64-unknown-linux-gnu --no-default-features --features alsa-backend
