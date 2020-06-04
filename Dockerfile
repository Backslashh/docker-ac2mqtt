FROM lsiobase/python:3.11

# set version label
ARG BUILD_DATE
ARG AC2MQTT_TAG
LABEL build_version="Build-date:- ${BUILD_DATE}"
LABEL maintainer="wjbeckett"

# set python to use utf-8 rather than ascii
ENV PYTHONIOENCODING="UTF-8"

RUN \
 echo "**** install packages ****" && \
 apk add --no-cache --upgrade && \
 apk add --no-cache \
    build-base \
	python2-dev \
	git \
	jq \
	py-pip && \
 echo "**** install pip pre-reqs ****" && \
 pip install --no-cache-dir \
	paho-mqtt \
	pyyaml \
	pycrypto && \
 echo "**** fetch ac2mqtt ****" && \
 mkdir -p \
	/app/ac2mqtt && \
 if [ -z ${AC2MQTT_TAG+x} ]; then \
	AC2MQTT_TAG=$(curl -sX GET https://api.github.com/repos/Backslashh/broadlink_ac_mqtt/tags \
	| jq -r 'first(.[]) | .name'); \
 fi && \
 echo "found ${AC2MQTT_TAG}" && \
 git clone https://github.com/Backslashh/broadlink_ac_mqtt.git /app/ac2mqtt && \
 cd /app/ac2mqtt && \
 git checkout ${AC2MQTT_TAG} && \
 cp -n sample_config.ym_ config.yml

# copy local files
COPY root/ /

VOLUME /config