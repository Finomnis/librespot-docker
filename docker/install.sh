
export CARGO_TARGET_DIR=/build
export CARGO_HOME=/build/cache
export PKG_CONFIG_ALLOW_CROSS=1
export PKG_CONFIG_PATH_aarch64_unknown_linux_gnu=/usr/lib/aarch64-linux-gnu/pkgconfig/
export PKG_CONFIG_PATH_arm_unknown_linux_gnueabihf=/usr/lib/arm-linux-gnueabihf/pkgconfig/
export PKG_CONFIG_PATH_arm_unknown_linux_gnueabi=/usr/lib/arm-linux-gnueabi/pkgconfig/
export PKG_CONFIG_PATH_mipsel_unknown_linux_gnu=/usr/lib/mipsel-linux-gnu/pkgconfig/

cargo build --release --target aarch64-unknown-linux-gnu --no-default-features --features alsa-backend
