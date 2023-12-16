#!/bin/bash

set -eu

NAME="${LIBRESPOT_NAME:-librespot}"
DEVICE_TYPE="${LIBRESPOT_DEVICE_TYPE:-speaker}"
BITRATE="${LIBRESPOT_BITRATE:-320}"
INITIAL_VOLUME="${LIBRESPOT_INITIAL_VOLUME:-70}"
AUDIO_FORMAT="${LIBRESPOT_AUDIO_FORMAT:-F32}"
AUTOPLAY_ENABLED="${LIBRESPOT_AUTOPLAY:-1}"
QUIET_ENABLED="${LIBRESPOT_QUIET:-1}"
VERBOSE_ENABLED="${LIBRESPOT_VERBOSE:-0}"

AUTOPLAY=""
if [ "x$AUTOPLAY_ENABLED" == "x1" ]; then
    AUTOPLAY="--autoplay"
fi

QUIET=""
if [ "x$QUIET_ENABLED" == "x1" ]; then
    QUIET="--quiet"
fi

VERBOSE=""
if [ "x$VERBOSE_ENABLED" == "x1" ]; then
    VERBOSE="--verbose"
fi


librespot \
    --cache /tmp/librespot \
    --name $NAME \
    --zeroconf-port 5354 \
    --device-type $DEVICE_TYPE \
    --bitrate $BITRATE \
    --initial-volume $INITIAL_VOLUME \
    --format $AUDIO_FORMAT \
    $AUTOPLAY \
    $QUIET \
    $VERBOSE
