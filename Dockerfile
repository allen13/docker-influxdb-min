FROM google/golang:1.3.1

ENV DEBIAN_FRONTEND noninteractive

#install docker and go build tools
RUN echo 'deb http://http.debian.net/debian wheezy-backports main' >> /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y -t wheezy-backports linux-image-amd64 \
       mercurial bzr protobuf-compiler flex bison \
       valgrind g++ make autoconf libtool libz-dev libbz2-dev curl \
       rpm build-essential git wget \
    && curl -sSL https://get.docker.io/ | sh

#Checkout InfluxDB version 0.8.6
RUN mkdir -p $GOPATH/src/github.com/influxdb && \
 cd $GOPATH/src/github.com/influxdb && \
 git clone https://github.com/influxdb/influxdb.git && \
 cd influxdb && git checkout tags/v0.8.6

WORKDIR $GOPATH/src/github.com/influxdb/influxdb

#Configure and build binary as a static binary
RUN ./configure
RUN echo "GO_BUILD_OPTIONS=--ldflags '-s -extldflags \"-static\"'" | cat - Makefile > /tmp/out && mv /tmp/out Makefile
RUN make build_binary

ADD config.toml $GOPATH/src/github.com/influxdb/influxdb/config.toml
ADD run_influxdb $GOPATH/src/github.com/influxdb/influxdb/run_influxdb
ADD Dockerfile.influxdb $GOPATH/src/github.com/influxdb/influxdb/Dockerfile

CMD docker build -t influxdb-min $GOPATH/src/github.com/influxdb/influxdb
