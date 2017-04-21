FROM docker.io/ubuntu
MAINTAINER Fábio Rodrigues Ribeiro <farribeiro@gmail.com>

RUN	\
	apt-get update \
	&& apt-get upgrade -y
RUN	apt-get install -y \
	libstdc++5 \
	firebird2.5-superclassic

VOLUME /var/

EXPOSE 3050
EXPOSE 22

CMD ["/usr/sbin/fbguard"]
