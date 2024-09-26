FROM soulteary/cronicle

RUN apk update && \
    apk add --no-cache docker curl

RUN adduser -S cronicle docker

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin


CMD dockerd --host=unix:///var/run/docker.sock --host=tcp://0.0.0.0:2375

ENV DOCKER_CLI_VERSION=27.3.1