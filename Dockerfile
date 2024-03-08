FROM python:3.8-slim
LABEL maintainer="RonZ-dev"

# install packages
RUN apt-get update && apt-get --yes upgrade

RUN apt-get --no-install-recommends --yes install \
    wget \
    ca-certificates

# Clean up
RUN apt-get clean && \
    rm --force --recursive /var/lib/apt/lists

#upgrade pip
RUN pip3 install --upgrade pip

# Adding Python modules
RUN pip3 install requests \
    pycryptodome \
    isodate \
    apsw \
    lxml \
    pynacl

WORKDIR ace

# install server
ARG ACE_STREAM_VERSION
ENV ACE_STREAM_VERSION "$ACE_STREAM_VERSION"

RUN echo "Building AceStream: $ACE_STREAM_VERSION"

RUN wget https://download.acestream.media/linux/acestream_${ACE_STREAM_VERSION}.tar.gz && \
    tar -xzf acestream_${ACE_STREAM_VERSION}.tar.gz && \
    rm acestream_${ACE_STREAM_VERSION}.tar.gz

EXPOSE 6878/tcp

ENTRYPOINT ["/ace/start-engine"]
CMD ["--client-console", "@/ace/config/acestream.conf"]
