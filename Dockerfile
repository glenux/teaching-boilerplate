FROM debian:jessie
MAINTAINER Glenn ROLLAND <glenux@glenux.net>

RUN mkdir -p /hop
ADD slides /hop/slides
ADD bin /hop/bin
ADD themes /home/themes
ADD Makefile /home/Makefile
RUN apt-get update && \
	apt-get install -y make 
WORKDIR /hop
RUN make install
CMD make
