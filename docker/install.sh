dpkg --add-architecture arm64
dpkg --add-architecture armhf
dpkg --add-architecture armel
#dpkg --add-architecture mipsel
apt-get update

apt-get install -y curl git build-essential crossbuild-essential-arm64 crossbuild-essential-armel crossbuild-essential-armhf pkg-config
apt-get install -y libasound2-dev libasound2-dev:arm64 libasound2-dev:armel libasound2-dev:armhf

curl https://sh.rustup.rs -sSf | sh -s -- -y
export PATH="/root/.cargo/bin/:${PATH}"
rustup target add aarch64-unknown-linux-gnu
rustup target add arm-unknown-linux-gnueabi
rustup target add arm-unknown-linux-gnueabihf
#rustup target add mipsel-unknown-linux-gnu

mkdir /.cargo && echo '[target.aarch64-unknown-linux-gnu]
linker = "aarch64-linux-gnu-gcc"' > /.cargo/config && echo '[target.arm-unknown-linux-gnueabihf]
linker = "arm-linux-gnueabihf-gcc"' >> /.cargo/config && echo '[target.arm-unknown-linux-gnueabi]
linker = "arm-linux-gnueabi-gcc"' >> /.cargo/config && echo '[target.mipsel-unknown-linux-gnu]
linker = "mipsel-linux-gnu-gcc"' >> /.cargo/config

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
