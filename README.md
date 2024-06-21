# Docker Ace Stream server

An [Ace Stream](http://www.acestream.org/) server Docker image.

- [Overview](#overview)
- [Building](#building)
- [Usage](#usage)
- [Reference](#reference)

## Overview

What this provides:

- Dockerized Ace Stream server (version `3.2.3`) running on docker container python 3.8-slim
- Dockerized web server which provides acces to python playback script [`playstream.py`](playstream.py) instructing server to:
	- Commence streaming of a given program ID.

Since a single HTTP endpoint exposed from the Docker container controls the server _and_ provides the output stream, this provides one of the easier methods for playback of Ace Streams on traditionally unsupported operating systems such as macOS.

## Building

To build Docker image:

```sh
$ docker compose build
```

To run Docker image:

```sh
$ docker compose up -d
```

Alternatively pull the Docker Hub image:

```sh
$ docker pull [todo]
```

## Usage

Docker will start 2 containers:
acestream-server and acestream-web

- Browse to the webinterface, default port is 4000, and input the acestream ID into the webpage.
![image](https://github.com/RonZ-dev/docker-acestream-server/assets/66950018/903e3e3e-b5c1-4b87-869d-fcc091b2efab)

- Server will respond with the http link (still needs to be fixed with external ip)
![image](https://github.com/RonZ-dev/docker-acestream-server/assets/66950018/0d35fad2-db3e-40fd-8dfb-a64e26678b33)


You can find acestream ID's here:
https://acestreamsearch.net/en/


## Reference

- Binary downloads: https://wiki.acestream.org/Download
- Ubuntu install notes: https://wiki.acestream.org/Install_Ubuntu
- HTTP API usage: https://wiki.acestream.org/Engine_HTTP_API
- `playstream.py` routines inspired by: https://github.com/jonian/acestream-launcher
