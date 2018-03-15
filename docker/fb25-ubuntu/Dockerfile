FROM ubuntu:latest
MAINTAINER Fábio Rodrigues Ribeiro <farribeiro@gmail.com>

RUN	\
	apt-get update \
	&& apt-get upgrade -y \
	&& apt-get install -y \
	libstdc++5 \
	firebird2.5-superclassic \
	--no-install-recommends

VOLUME	"/mnt/"

EXPOSE	3050

COPY	startup.sh /

RUN	chmod 744 startup.sh

CMD	"/startup.sh"
