# Raspberry Pi Setup Guide

This guide is specific for Raspberry Pi's (in my case a Raspberry Pi 3B+).
But for other boards, it works similar, probably.

## General Setup

Install your Raspberry Pi like you would usually. Set up a password, enable ssh,
set up your soundcard drivers, and so on.

Make sure that the user you use from now on has the UID and GID `1000`.
By default, the user `pi` has the correct GID/UID, so don't create your own user, just use
the `pi` user.

This is important because that UID/GID is hardcoded when the PulseAudio device gets mounted into the Docker container.
I wasn't able to find a proper way to make this configurable. Pull requests welcome.

## PulseAudio Setup

This project uses PulseAudio for audio output. Therefore, it has to be set up and configured correctly.

Install PulseAudio:
```
sudo apt update
sudo apt install pulseaudio pamix
systemctl --user enable pulseaudio
```

If you use the system as a headless setup (= without screen),
PulseAudio only starts if a user is logged in.
Therefore, it is important to enable Auto-Login.

For that, enter `sudo raspi-config` and find and enable the option `Console Autologin`.

Then, configure pulseaudio correctly to get the best possible quality.
The exact setup might be different for everybody,
so I just post my setup for reference (file: `/etc/pulse/daemon.conf`):

```
default-sample-format = float32le
default-sample-rate = 48000
alternate-sample-rate = 44100
default-sample-channels = 2
default-channel-map = front-left,front-right
resample-method = soxr-vhq
enable-lfe-remixing = no
high-priority = yes
nice-level = -11
realtime-scheduling = yes
realtime-priority = 9
rlimit-rtprio = 9
daemonize = no
default-fragment-size-msec = 15
```

The sample rates `48000` and `44100` are important, because those are the sample rates
used by Spotify. (At least I think so, correct me if I'm wrong)


## Docker Setup

librespot itself will be deployed to the Raspberry Pi through a docker image.
Therefore, docker needs to be set up and configured.

Install docker:
```
sudo apt update
sudo apt install docker.io
```

## Portainer

This step is optional, but recommended.

I personally prefer to manage my systems through a UI rather than through command line.
Therefore I use Portainer to manage my Docker containers. Again, this is not required for this
project, but it makes docker and especially docker-compose much easier to manage.

Alternatively, if a command line is preferred, the tool 'docker-compose' has to be installed instead of Portainer.
The installation of docker-compose will not be described here, and later steps will assume that you installed Portainer.

Install portainer:
```
sudo docker volume create portainer_data
sudo docker run -d -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce
```

You can then log into Portainer on `http://<raspberry-pi-ip-address>:9000`.

Log in, create your username and password, and choose that you want to manage a local docker installation.


## Create and run a librespot container

Inside or portainer, click on your instance, and select the `Stacks` menu. Click `Add stack`, name it whatever you want, and use the following docker-compose config for it:


```
version: "2"
services:
  librespot:
    container_name: librespot
    image: "ghcr.io/finomnis/librespot-docker"
    restart: unless-stopped
    tty: true  # if you want color in your log
    ports:
        - "5353:5353/udp"
        - "5354:5354/tcp"
    volumes:
        - /run/user/1000/pulse:/run/user/1000/pulse
```

Explanation:

- `image: "ghcr.io/finomnis/librespot-docker"`: This image gets built from this repository. It contains the librespot player.
  This image is tagged manually to whenever there is a proper release. If you want to use the latest version, use `ghcr.io/finomnis/librespot-docker:main`.
- `tty: true`: Runs librespot in a virtual TTY, enabling nice color log.
- `5353:5353/udp` and `5354:5354/tcp`: Those are the ports required by librespot.
- `/run/user/1000/pulse:/run/user/1000/pulse`: This volume mounts in the pulseaudio device, giving the container the capability to play audio.
                                               As previously mentioned, this only works if the host user has the UID/GID `1000`.

Then, click `Deploy the stack` to start it.

If you have another device running Spotify in the same network, the `librespot` device should now be visible and able to recieve a Spotify stream.

## Further steps

You can now edit the environment variables as described in the main documentation, to customize things like the name of the device.
