# librespot-docker

A [librespot] Docker container for your Raspberry Pi or PC.

Convert your Raspberry Pi or PC to a [Spotify] streaming target!

## Docker Image

<a href="https://github.com/Finomnis/librespot-docker/pkgs/container/librespot-docker"><img alt="ghcr.io librespot-docker" src="https://img.shields.io/badge/ghcr.io-librespot--docker-blue"></a>

## Quick start

Make sure you have a PulseAudio server installed and running. <br/>
Detailed instructions on how to setup PulseAudio and Docker on a Raspberry Pi can be found [here](./RASPBERRY_PI_SETUP_GUIDE.md).

To run the librespot Docker image successfully, you have to mount in the PulseAudio device as `/run/user/1000/pulse` to the Docker container and publish the
ports `5353/udp` and `5354/tcp`.

This all can be achieved by the following docker-compose script:

```
version: "2"
services:
  librespot:
    container_name: librespot
    image: "ghcr.io/finomnis/librespot-docker"
    restart: unless-stopped
    tty: true  # if you want color in your log
    network_mode: host
    volumes:
        - /run/user/1000/pulse:/run/user/1000/pulse
```

If you are not the user with id `1000`, you might have to adjust the first `1000` according to your user id.

To customize your librespot instance, here is a more complete script including environment variables:

```
version: "2"
services:
  librespot:
    container_name: librespot
    image: "ghcr.io/finomnis/librespot-docker"
    restart: unless-stopped
    tty: true
    network_mode: host
    environment:
        - LIBRESPOT_NAME=librespot
        - LIBRESPOT_DEVICE_TYPE=speaker
        - LIBRESPOT_BITRATE=320
        - LIBRESPOT_INITIAL_VOLUME=70
        - LIBRESPOT_AUDIO_FORMAT=F32
        - LIBRESPOT_AUTOPLAY=1
    volumes:
        - /run/user/1000/pulse:/run/user/1000/pulse
```

## Environment Variables

| Variable                  | Default      | Description                                                                                   |
| ------------------------- | ------------ | --------------------------------------------------------------------------------------------- |
| LIBRESPOT_NAME            | `librespot`  | The name displayed in Spotify.                                                                 |
| LIBRESPOT_DEVICE_TYPE     | `speaker`    | The device type displayed in Spotify. For more information read [librespot options].          |
| LIBRESPOT_BITRATE         | `320`        | The quality of the spotify stream, in kbps. For more information read [librespot options].    |
| LIBRESPOT_INITIAL_VOLUME  | `70`         | The initial default playback volume, in percent.                                              |
| LIBRESPOT_AUDIO_FORMAT    | `F32`        | The playback audio format. For more information read [librespot options].                     |
| LIBRESPOT_AUTOPLAY        | `1`          | Whether random tracks should be played after the song queue is finished. Possible values: `0` or `1`.     |


# Raspberry Pi Setup Guide

Read [this guide](./RASPBERRY_PI_SETUP_GUIDE.md) for instructions on how to set up a Raspberry Pi.




[//]: <> (Links below...................)
[librespot]: https://github.com/librespot-org/librespot
[Spotify]: http://spotify.com/
[librespot options]: https://github.com/librespot-org/librespot/wiki/Options
