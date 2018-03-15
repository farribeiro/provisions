FROM fedora:latest

MAINTAINER Fábio Rodrigues Ribeiro <farribeiro@gmail.com>

RUN	dnf update -y \
	&& dnf -y install \
	ansible \
	python-dnf \
	libselinux-python

WORKDIR [ "/tmp/ansible" ]
