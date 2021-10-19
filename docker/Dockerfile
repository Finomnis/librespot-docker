ARG LIBRESPOT_VERSION="0.3.0"
ARG DEBIAN_VERSION="stretch"

###################################
# Build librespot
#
FROM debian:$DEBIAN_VERSION

RUN apt-get update
RUN apt-get install -y git

ARG LIBRESPOT_VERSION

RUN git clone --branch v$LIBRESPOT_VERSION --depth 1 https://github.com/librespot-org/librespot.git /src
WORKDIR /src

COPY install.sh /opt/install.sh
RUN /opt/install.sh
