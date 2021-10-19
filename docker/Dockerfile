ARG LIBRESPOT_VERSION="0.3.0"
ARG DEBIAN_VERSION="11.1"

###################################
# Build librespot
#
FROM debian:$DEBIAN_VERSION as librespot

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --yes \
  cargo \
  libpulse-dev \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ARG LIBRESPOT_VERSION
RUN cargo install librespot --version $LIBRESPOT_VERSION --no-default-features --features pulseaudio-backend


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
COPY --from=librespot /root/.cargo/bin/librespot /usr/local/bin/librespot

# Sanity check if librespot is installed correctly
RUN librespot --version

# Ports
EXPOSE 5353/udp
EXPOSE 5354/udp

# run
ENTRYPOINT ["/start.sh"]
