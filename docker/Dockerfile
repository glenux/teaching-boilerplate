FROM node:bullseye-slim
MAINTAINER Glenn ROLLAND <glenux@glenux.net>

RUN apt-get update \
 && apt-get install -y --no-install-recommends python3 python3-pip pipenv \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
 && truncate -s 0 /var/log/*log

# Tools for running the common parts
RUN apt-get update \
 && apt-get install -y --no-install-recommends make build-essential inotify-tools gosu unzip \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
 && truncate -s 0 /var/log/*log

# Tools for building pdfs
RUN apt-get update \
 && apt-get install -y --no-install-recommends make pdftk m4 chromium \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
 && truncate -s 0 /var/log/*log

# External tools
# yq => manage YML
RUN curl -o /usr/local/bin/yq \
         https://github.com/mikefarah/yq/releases/download/v4.18.1/yq_linux_amd64 \
 && chmod +x /usr/local/bin/yq

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

