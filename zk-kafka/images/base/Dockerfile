# Base docker image for Java-based server applications

#9 - jre causes trouble with ZooKeeper
FROM java:8-jre
LABEL maintainer="docker@pseudonymous.me"

ENV IMG_USER docker
ENV IMG_GROUP docker

RUN groupadd -r docker \
    && useradd -r -g docker docker

ADD gotpl /usr/bin/gotpl
RUN chown root:root /usr/bin/gotpl \
    && chmod 755 /usr/bin/gotpl 