#!/bin/bash
docker build -t influxdb-build .
docker run --rm  -v /var/run/docker.sock:/var/run/docker.sock influxdb-build
docker images
