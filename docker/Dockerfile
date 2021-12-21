FROM node:bullseye-slim
MAINTAINER Glenn ROLLAND <glenux@glenux.net>

RUN apt-get update \
 && apt-get install -y --no-install-recommends python3 python3-pip pipenv \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
 && truncate -s 0 /var/log/*log

RUN apt-get update \
 && apt-get install -y --no-install-recommends make build-essential inotify-tools chromium gosu unzip m4 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
 && truncate -s 0 /var/log/*log

COPY . /app
WORKDIR /app

ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PIPENV_HIDE_EMOJIS=1 \
    PIPENV_VENV_IN_PROJECT=1

RUN ln -sf python3 /usr/bin/python \
 && make prepare SYSTEM_INSTALL=1

ENTRYPOINT ["/app/docker/entrypoint.sh"]
CMD ["watch"]

