FROM ruby:alpine

RUN	apk -U update \
	&& apk -U add \
	bash \
	gcc \
	g++ \
	make

VOLUME "/mnt/"

WORKDIR "/mnt"

ENTRYPOINT [ "bash", "--login" ]
