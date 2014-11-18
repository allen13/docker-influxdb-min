.PHONY: build deploy destroy shell test

PORT_MAPPINGS := -p 8083:8083 -p 8086:8086 -p 8084:8084 -p 8090:8090 -p 8099:8099

default: build
build:
	docker build -t influxdb-build .
	docker run -rm -v /var/run/docker.sock:/var/run/docker.sock influxdb-build
deploy:
	docker run -d $(PORT_MAPPINGS) influxdb-min > pid
destroy:
	docker rm -f $(shell cat pid) && rm pid
shell:
	docker run --rm  $(PORT_MAPPINGS) -t -i influxdb-min /bin/ash
test:
	go test ./integration
