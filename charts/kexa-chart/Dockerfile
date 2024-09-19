#FROM jordan/rundeck:latest

#RUN apt-get update

#RUN apt-get install -y --allow-downgrades python3-pkg-resources=52.0.0-4+deb11u1
#RUN apt-get install -y curl python3 python3-pip python3-setuptools

#RUN python3 --version
#RUN python3 -m pip --version

#COPY files/plugins/. /home/rundeck/libext
#COPY --chown=rundeck:root files/resources/. /home/rundeck/resources


FROM jordan/rundeck:latest

USER root

RUN apt-get update && \
    apt-get install -y --allow-downgrades python3-pkg-resources=52.0.0-4+deb11u1 && \
    apt-get install -y python3 python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/rundeck-plugins && \
    chown -R rundeck /opt/rundeck-plugins

USER rundeck

EXPOSE 4440