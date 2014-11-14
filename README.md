#Build A Small SkyDNS Docker Image
#Minimum docker image for influxdb

* See [Create The Smallest Possible Docker Container](http://blog.xebia.com/2014/07/04/create-the-smallest-possible-docker-container/)

###Build image:

	./build.sh

It builds two images, first influxdb-build, and then influxdb-min by running influxdb-build.

You should see some outputs similar to:

    ...
    Successfully built c2a85185ca6f
    REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
    influxdb-min        latest              a83b0d6b0a88        1 seconds ago       14.14 MB
    influxdb-build      latest              2544322de668        3 seconds ago       1.328 GB

From here you can do what you want form your minimal image.
