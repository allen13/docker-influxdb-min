####Minimum docker image from busybox for influxdb
* Total size: 18.02 MB

* See [Create The Smallest Possible Docker Container](http://blog.xebia.com/2014/07/04/create-the-smallest-possible-docker-container/)
* Influxdb docker image referenced from: [tutum-docker-influxdb](https://github.com/tutumcloud/tutum-docker-influxdb)

It builds two images, first influxdb-build, and then influxdb-min by running influxdb-build.

You should see some outputs similar to:

    ...
    Successfully built c2a85185ca6f
    REPOSITORY             TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
    influxdb-min           latest              c0f1eba0f177        7 minutes ago       18.02 MB
    influxdb-build         latest              65fe5c5e641b        7 minutes ago       1.526 GB



####Runtime configuration templating through environment variables
Currently supported variables:

	docker run -d \
	-e SEEDS="\"master:8090\"" \
	-e REPLICATION_FACTOR="2" \
	-e HOSTNAME="auto" \
	influxdb-min
	
Add more substitutions to run_influxdb as needed.

####Interacting with the image locally
Use the Makefile for convienient local interactions:
 - **make or make build** - build image
 - **make deploy** - detached image deploy
 - **make test** - test deployed image
 - **make destroy** - destroy deployed image
 - **make shell** - go interactive with the ash shell
