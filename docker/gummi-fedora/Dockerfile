FROM fedora:latest

COPY	startup.sh /

RUN	dnf update -y \
	&& dnf install -y gummi \
	xauth \
	texlive-*\
	&& groupadd -g 1000 gummi \
	&& useradd -u 1000 -g gummi gummi \
	&& chmod +x startup.sh

USER	gummi

VOLUME "/mnt"

