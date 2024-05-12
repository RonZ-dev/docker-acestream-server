FROM phusion/baseimage:jammy-1.0.4
LABEL maintainer="Meikkun"

RUN apt-get update && apt-get --yes upgrade && \
	# install packages
	apt-get --no-install-recommends --yes install \
		curl \
		wget \
		libpython3.10 \
		net-tools \
		python3-pip \
		python3-apsw \
		python3-lxml \
		python3-m2crypto \
		python3-pkg-resources && \
	# clean up
	apt-get clean && \
	rm --force --recursive /var/lib/apt/lists && \
	#pip
	python3.10 -m pip install --upgrade pip && \
	# Adding Python modules
	pip3 install requests \
	pycryptodome \
	isodate \
	apsw \
	lxml \
	pynacl \
	iso8601 \
	aiohttp

WORKDIR ace

	# install server
	RUN wget "https://download.acestream.media/linux/acestream_3.2.3_ubuntu_22.04_x86_64_py3.10.tar.gz" &&\
	tar -xzf acestream_3.2.3_ubuntu_22.04_x86_64_py3.10.tar.gz

EXPOSE 6878/tcp

ENTRYPOINT ["/ace/start-engine"]
CMD ["--client-console"]
