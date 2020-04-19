FROM node:buster-slim
MAINTAINER Glenn ROLLAND <glenux@glenux.net>

RUN apt-get update && \
	apt-get install -y make

COPY . /app
WORKDIR /app
RUN make prepare
CMD make watch
