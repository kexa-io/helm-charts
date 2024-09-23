FROM soulteary/cronicle

RUN apk update && \
    apk add docker-cli curl

RUN adduser -S cronicle docker


RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin

# RUN chown -R 1000:3000 /opt || true && \
#     chmod -R u+rwx,g+rwx /opt || true

# RUN chown -R 1000:3000 / || true && \
#     chmod -R u+rwx,g+rwx / || true

# RUN chmod +wrx /opt/cronicle/bin/shell-plugin.js

ENV DOCKER_CLI_VERSION=23.0.3