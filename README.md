# Docker Ace Stream server

An [Ace Stream](http://www.acestream.org/) server Docker image.

- [Overview](#overview)
- [Building](#building)
- [Usage](#usage)
- [Reference](#reference)
- [OPTIONAL: Use the container behind a dockerized VPN](#optional-use-the-container-behind-a-dockerized-vpn)

## Introduction

This is based on previous work:
https://github.com/magnetikonline/docker-acestream-server
https://github.com/RonZ-dev/docker-acestream-server

Both built based on Debian images, but acestream isn't updating Debian binaries since 2 years ago.
This new image is based on Ubuntu 22.04 to be able to run latest Ubuntu x64 python3 acestream version (currently 3.2.3).

## Overview

What this provides:

- Dockerized Ace Stream server (version `3.2.3`) running on docker container `phusion/baseimage` (minimal Ubuntu 22.04)
- Dockerized web server which provides acces to python playback script [`playstream.py`](playstream.py) instructing server to:
	- Commence streaming of a given program ID.

Since a single HTTP endpoint exposed from the Docker container controls the server _and_ provides the output stream, this provides one of the easier methods for playback of Ace Streams on traditionally unsupported operating systems such as macOS.

## Building

To build Docker image:

1. Download the Dockerfile or clone the repo:

```sh
$ git clone https://github.com/Meikkun/docker-acestream-server.git
```

2. Build the image

```sh
$ cd docker-acestream-server
$ sudo docker build -t "acestream-ubuntu:v3.2.3" .
```

3. Run the container

```sh
$ docker run -d \
        --volume  ./config/acestream.conf:/acestream.conf \
		-p 6878:6878 \
        --name acestream \
                acestream-ubuntu:v3.2.3
```

On Linux systems it is recommended to bind the cache to a temporary mount to avoid bloating the container:
```sh
$ docker run -d \
        --volume  ./config/acestream.conf:/acestream.conf \
		--tmpfs "/root/.ACEStream:noexec,rw,size=4096m" \
		-p 6878:6878 \
        --name acestream \
                acestream-ubuntu:v3.2.3
```

4. Check it works

```sh
$ curl http://127.0.0.1:6878/webui/api/service?method=get_version
# {"result": {"platform": "linux", "version": "3.2.3", "code": 3020300, "websocket_port": 42865}, "error": null}
```

## Usage

Get the stream by calling the engine providing an acestream ID (from VLC, for example):

```
http://127.0.0.1:6878/ace/getstream?id=ACEID
```

If you are playing the stream from a different device than the one running the engine, just use the server IP instead of localhost.

## OPTIONAL: Use the container behind a dockerized VPN

In case you prefer using acestream behind a VPN of your choice, you can achieve this by setting up a separate VPN container and linking the acestream network to that one.
For example, you can use OpenVPN container from: https://github.com/dperson/openvpn-client

Set up OpenVPN with the provider you prefer and open the port 6878 on that container:

```sh
$ sudo docker run -it --cap-add=NET_ADMIN -d \
            -v /home/meiden/utils/mullvad_hk:/vpn \
            --sysctl net.ipv6.conf.all.disable_ipv6=0 \
            -p 6878:6878 \
            --name openvpn \
            dperson/openvpn-client
```
Then run acestream without any port by linking the network:

```sh
$ docker run -d \
        --volume  ./config/acestream.conf:/acestream.conf \
		--network=container:openvpn \
        --name acestream \
                acestream-ubuntu:v3.2.3
```

Test it and it should work:

```sh
$ docker exec openvpn curl "https://api.ipify.org/"
# X.X.X.X # it must return the remote external IP from VPN provider
```

```sh
$ curl curl http://127.0.0.1:6878/webui/api/service?method=get_version
# {"result": {"platform": "linux", "version": "3.2.3", "code": 3020300, "websocket_port": 42865}, "error": null}
```

## Reference

- Binary downloads: https://docs.acestream.net/products/#linux
- HTTP API usage: https://wiki.acestream.org/Engine_HTTP_API
- Dperson's OpenVPN container: https://github.com/dperson/openvpn-client
- Original Acestream container based on Debian: https://github.com/magnetikonline/docker-acestream-server
- Updated Acesrteam container based on Debian: https://github.com/RonZ-dev/docker-acestream-server
