#!/bin/bash

set -m
CONFIG_FILE="/config/influxdb.conf"

# Dynamically change the value of 'max-open-shards' to what 'ulimit -n' returns
sed -i "s/^max-open-shards.*/max-open-shards = $(ulimit -n)/" ${CONFIG_FILE}

# Configure InfluxDB Cluster
if [ -n "${FORCE_HOSTNAME}" ]; then
    if [ "${FORCE_HOSTNAME}" == "auto" ]; then
        #set hostname with IPv4 eth0
        HOSTIPNAME=$(ip a show dev eth0 | grep inet | grep eth0 | sed -e 's/^.*inet.//g' -e 's/\/.*$//g')
        /usr/bin/perl -p -i -e "s/hostname = \"localhost\"/hostname = \"${HOSTIPNAME}\"/g" ${CONFIG_FILE}
    else
        /usr/bin/perl -p -i -e "s/hostname = \"localhost\"/hostname = \"${FORCE_HOSTNAME}\"/g" ${CONFIG_FILE}
    fi
fi

if [ -n "${SEEDS}" ]; then
    SEEDS=$(eval SEEDS=$SEEDS ; echo $SEEDS | grep '^\".*\"$' || echo "\""$SEEDS"\"" | sed -e 's/, */", "/g')
    /usr/bin/perl -p -i -e "s/peers = \"\"/peers = [${SEEDS}]/g" ${CONFIG_FILE}
fi

if [ -n "${REPLI_FACTOR}" ]; then
    /usr/bin/perl -p -i -e "s/replication = 1/replication = ${REPLI_FACTOR}/g" ${CONFIG_FILE}
fi

if [ "${SSL_CERT}" == "**None**" ]; then
    unset SSL_CERT
fi

if [ "${SSL_SUPPORT}" == "**False**" ]; then
    unset SSL_SUPPORT
fi

echo "=> Starting InfluxDB ..."

exec /opt/influxdb/influxd -config=${CONFIG_FILE}
