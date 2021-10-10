FROM node:bullseye-slim
MAINTAINER Glenn ROLLAND <glenux@glenux.net>

RUN apt-get update && \
	apt-get install -y make build-essential

RUN apt-get update && \
	apt-get install -y python3 python3-pip

RUN pip3 install pipenv

COPY . /app
WORKDIR /app

ENV LANG=C
ENV LC_ALL=C

RUN make prepare

ENTRYPOINT ["/app/docker/entrypoint.sh"]
CMD ["watch"]
