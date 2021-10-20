
mkdir /build && \
  mkdir /pi-tools && \
  curl -L https://github.com/raspberrypi/tools/archive/648a6eeb1e3c2b40af4eb34d88941ee0edeb3e9a.tar.gz | tar xz --strip-components 1 -C /pi-tools

export CARGO_TARGET_DIR=/build
export CARGO_HOME=/build/cache
export PKG_CONFIG_ALLOW_CROSS=1
export PKG_CONFIG_PATH_aarch64_unknown_linux_gnu=/usr/lib/aarch64-linux-gnu/pkgconfig/
export PKG_CONFIG_PATH_arm_unknown_linux_gnueabihf=/usr/lib/arm-linux-gnueabihf/pkgconfig/
export PKG_CONFIG_PATH_arm_unknown_linux_gnueabi=/usr/lib/arm-linux-gnueabi/pkgconfig/
export PKG_CONFIG_PATH_mipsel_unknown_linux_gnu=/usr/lib/mipsel-linux-gnu/pkgconfig/

cargo build --release --target aarch64-unknown-linux-gnu --no-default-features --features alsa-backend
