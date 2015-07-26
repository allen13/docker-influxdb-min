FROM debian:jessie

RUN apt-get update && apt-get install -y curl

# Install InfluxDB
ENV INFLUXDB_VERSION 0.9.2-rc1
RUN curl -s -o /tmp/influxdb_latest_amd64.deb https://s3.amazonaws.com/influxdb/influxdb_${INFLUXDB_VERSION}_amd64.deb && \
  dpkg -i /tmp/influxdb_latest_amd64.deb && \
  rm /tmp/influxdb_latest_amd64.deb && \
  rm -rf /var/lib/apt/lists/*

ADD influxdb.conf /config/influxdb.conf
ADD run.sh /run.sh
RUN chmod +x /*.sh

ENV SSL_SUPPORT **False**
ENV SSL_CERT **None**

# Admin server
EXPOSE 8083

# HTTP API
EXPOSE 8086

# Clustering
EXPOSE 8088

# Raft port (for clustering, don't expose publicly!)
#EXPOSE 8090

# Protobuf port (for clustering, don't expose publicly!)
#EXPOSE 8099

CMD ["/run.sh"]
