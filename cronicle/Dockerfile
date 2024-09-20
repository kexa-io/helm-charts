FROM soulteary/cronicle

RUN apk update && \
    apk add docker-cli

RUN adduser cronicle docker

ENV DOCKER_CLI_VERSION=23.0.3