####Minimum docker image from busybox for influxdb
* Currently does not support rocksdb storage engine (need to add it to the build)
* Total size: 16.57 MB

* See [Create The Smallest Possible Docker Container](http://blog.xebia.com/2014/07/04/create-the-smallest-possible-docker-container/)

####Build image:

	./build.sh

It builds two images, first influxdb-build, and then influxdb-min by running influxdb-build.

You should see some outputs similar to:

    ...
    Successfully built c2a85185ca6f
    REPOSITORY             TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
    influxdb-min           latest              013634f3287e        12 minutes ago      16.57 MB
    influxdb-build         latest              82d203d906f7        12 minutes ago      1.328 GB


####Runtime configuration templating through environment variables
Currently supports setting seed-servers and replication-factor.

	docker run -e SEEDS="\"master:8090\"" -e REPLICATION_FACTOR="2" influxdb-min /bin/ash
	
Add more substitutions to run_influxdb as needed.
