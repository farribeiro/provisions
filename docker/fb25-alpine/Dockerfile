FROM alpine:latest

RUN	apk -U add \
	g++ \
	make \
	gcc

RUN	apk -U add \
	wget \
	ca-certificates \
	&& wget	"http://sourceforge.net/projects/firebird/files/firebird/2.5.7-Release/Firebird-2.5.7.27050-0.tar.bz2/download"
