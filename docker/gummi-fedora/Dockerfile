FROM fedora

COPY	startup.sh /

RUN	dnf update -y 
RUN	dnf install -y gummi \
	xauth \
	texlive \
	texlive-collection-latex \
	texlive-collection-xetex \
	texlive-collection-fontsrecommended \
	texlive-collection-langportuguese \
	texlive-babel-portuges
RUN	groupadd -g 1000 gummi 
RUN	useradd -u 1000 -g gummi gummi 
RUN	chmod +x startup.sh

USER	gummi

VOLUME "/mnt"

CMD "/startup.sh"
