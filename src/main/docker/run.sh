#!/bin/bash
echo "********************************************************"
echo "Waiting for the configuration server to start on port $CONFIGSERVER_PORT"
echo "********************************************************"
while ! `nc -z config-service $CONFIGSERVER_PORT `; do sleep 3; done
echo ">>>>>>>>>>>> Configuration Server has started"

########################################################################################################################
# Monitor HTTP traffic on port 8080 including request and response headers and message body.
########################################################################################################################
nohup tcpdump -A -s 0 'tcp port 8080 and (((ip[2:2] - ((ip[0]&0xf)<<2)) - ((tcp[12]&0xf0)>>2)) != 0)' \
-w /usr/local/zipkin/pcap/licensing.pcap &

########################################################################################################################
echo "********************************************************"
echo "Starting licensing-service "
echo "********************************************************"
java \
-Djava.security.egd=file:/dev/./urandom \
-Dspring.cloud.config.uri=$CONFIGSERVER_URI \
-Dspring.profiles.active=$PROFILE \
-jar /usr/local/zipkin/@project.build.finalName@.jar