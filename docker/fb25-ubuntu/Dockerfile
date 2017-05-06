FROM ubuntu:latest
MAINTAINER Fábio Rodrigues Ribeiro <farribeiro@gmail.com>

RUN	\
	apt-get update \
	&& apt-get upgrade -y \
	&& apt-get install -y \
	libstdc++5 \
	firebird2.5-superclassic


VOLUME [ "/mnt/" ]

WORKDIR [ "/mnt/" ]
EXPOSE 3050

CMD ["/usr/sbin/fbguard"]
