FROM docker.io/fedora
MAINTAINER Fábio Rodrigues Ribeiro <farribeiro@gmail.com>

RUN dnf update -y
RUN dnf install ansible python-dnf libselinux-python -y

WORKDIR /tmp/ansible
