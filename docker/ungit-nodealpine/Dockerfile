FROM node:alpine
MAINTAINER "Fabio Rodrigues Ribeiro <farribeiro@gmail.com>"

RUN	apk -U add git \
	&& npm -g i ungit

USER "node"

VOLUME "/home/fribeiro:/mnt"

EXPOSE "8448:8448"

# ENTRYPOINT "ungit"

CMD [ "ungit", "--no-b" ]
