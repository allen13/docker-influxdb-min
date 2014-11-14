FROM google/golang:1.3.1

ENV DEBIAN_FRONTEND noninteractive
RUN echo 'deb http://http.debian.net/debian wheezy-backports main' >> /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y -t wheezy-backports linux-image-amd64 \
       mercurial bzr protobuf-compiler flex bison \
       valgrind g++ make autoconf libtool libz-dev libbz2-dev curl \
       rpm build-essential git wget \
    && curl -sSL https://get.docker.io/ | sh

RUN mkdir -p $GOPATH/src/github.com/influxdb && cd $GOPATH/src/github.com/influxdb && git clone https://github.com/influxdb/influxdb.git
WORKDIR $GOPATH/src/github.com/influxdb/influxdb
RUN ./configure
RUN echo "GO_BUILD_OPTIONS=--ldflags '-s -extldflags \"-static\"'" | cat - Makefile > /tmp/out && mv /tmp/out Makefile
RUN make build_binary
ADD Dockerfile.influxdb $GOPATH/src/github.com/influxdb/influxdb/Dockerfile

CMD docker build -t influxdb-min $GOPATH/src/github.com/influxdb/influxdb
