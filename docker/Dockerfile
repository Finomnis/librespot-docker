ARG LIBRESPOT_VERSION="0.3.0"
ARG DEBIAN_VERSION="11.1"

###################################
# Build librespot
#
FROM --platform=$BUILDPLATFORM debian:$DEBIAN_VERSION as librespot-cross

# Install target compilation targets
RUN dpkg --add-architecture arm64
RUN dpkg --add-architecture armhf
RUN dpkg --add-architecture armel

# Add cross compilers and dependencies
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --yes \
    curl git build-essential crossbuild-essential-arm64 crossbuild-essential-armel crossbuild-essential-armhf pkg-config \
    libpulse-dev libpulse-dev:arm64 libpulse-dev:armel libpulse-dev:armhf \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin/:${PATH}"
RUN rustup target add aarch64-unknown-linux-gnu
RUN rustup target add arm-unknown-linux-gnueabi
RUN rustup target add arm-unknown-linux-gnueabihf

# Configure rust for cross compilation
RUN mkdir /.cargo && \
    echo '[target.aarch64-unknown-linux-gnu]\nlinker = "aarch64-linux-gnu-gcc"' > /.cargo/config && \
    echo '[target.arm-unknown-linux-gnueabihf]\nlinker = "arm-linux-gnueabihf-gcc"' >> /.cargo/config && \
    echo '[target.arm-unknown-linux-gnueabi]\nlinker = "arm-linux-gnueabi-gcc"' >> /.cargo/config

# Set rust cross compilation environment variables
ENV CARGO_TARGET_DIR=/build
ENV CARGO_HOME=/build/cache
ENV PKG_CONFIG_ALLOW_CROSS=1
ENV PKG_CONFIG_PATH_aarch64_unknown_linux_gnu=/usr/lib/aarch64-linux-gnu/pkgconfig/
ENV PKG_CONFIG_PATH_arm_unknown_linux_gnueabihf=/usr/lib/arm-linux-gnueabihf/pkgconfig/
ENV PKG_CONFIG_PATH_arm_unknown_linux_gnueabi=/usr/lib/arm-linux-gnueabi/pkgconfig/

# Download librespot
ARG LIBRESPOT_VERSION
RUN git clone --branch v$LIBRESPOT_VERSION --depth 1 https://github.com/librespot-org/librespot.git /src
WORKDIR /src

# Create directories for artifacts
RUN mkdir -p \
    /artifacts/linux/amd64 \
    /artifacts/linux/arm64 \
    /artifacts/linux/arm/v7 \
    /artifacts/linux/arm/v6

# Build librespot binaries
RUN cargo build --release --no-default-features --features pulseaudio-backend \
    cp $CARGO_TARGET_DIR/release/librespot /artifacts/linux/amd64/ \
    rm -rf $CARGO_TARGET_DIR
RUN cargo build --release --target aarch64-unknown-linux-gnu --no-default-features --features pulseaudio-backend \
    cp $CARGO_TARGET_DIR/aarch64-unknown-linux-gnu/release/librespot /artifacts/linux/arm64/ \
    rm -rf $CARGO_TARGET_DIR
RUN cargo build --release --target arm-unknown-linux-gnueabihf --no-default-features --features pulseaudio-backend \
    cp $CARGO_TARGET_DIR/arm-unknown-linux-gnueabihf/release/librespot /artifacts/linux/arm/v7/ \
    rm -rf $CARGO_TARGET_DIR
RUN cargo build --release --target arm-unknown-linux-gnueabi --no-default-features --features pulseaudio-backend \
    cp $CARGO_TARGET_DIR/arm-unknown-linux-gnueabi/release/librespot /artifacts/linux/arm/v6/ \
    rm -rf $CARGO_TARGET_DIR


###################################
# Build final system
#
FROM debian:$DEBIAN_VERSION

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --yes \
  libpulse0 \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set up the user
RUN groupadd -g 1000 pi && useradd pi -s /bin/bash -m -u 1000 -g 1000

# Pulse config
COPY pulse-client.conf /etc/pulse/client.conf

# Switch to user space
USER pi

# Install librespot
ARG TARGETPLATFORM
COPY --from=librespot-cross /artifacts/$TARGETPLATFORM/librespot /usr/local/bin/librespot

# Sanity check if librespot is installed correctly
RUN librespot --version

# Ports
EXPOSE 5353/udp
EXPOSE 5354/udp

# Execute start script at runtime
COPY start.sh /start.sh
ENTRYPOINT ["/start.sh"]
