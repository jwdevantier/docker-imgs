
FROM pseudonymous/jre-base

LABEL maintainer="docker@pseudonymous.me"

ARG GPG_KEY=C823E3E5B12AF29C67F81976F5CECB3CB5E9BD2D
ARG DISTRO_NAME=zookeeper-3.4.10

# Like scheme let-bindings, hence two separate ENV instructions
ENV ZOO_BASE_DIR=/opt/zookeeper
ENV ZOO_CONF_DIR=$ZOO_BASE_DIR/conf \
    ZOO_DATA_DIR=$ZOO_BASE_DIR/data \
    ZOO_DATA_LOG_DIR=$ZOO_BASE_DIR/datalog \
    KAFKA_LOG4J_OPTS=-Dlog4j.configuration=file:/${ZOO_CONF_DIR}/log4j.properties

RUN apt-get update \
      && apt-get install -y \
      gnupg \
      && rm -rf /var/lib/apt/lists/*

# Download, verify & install zookeeper to /zookeeper
RUN set -ex; \
    apt-get update && apt-get install -y gnupg && rm -rf /var/lib/apt/lists/*; \
    wget --quiet "http://www.apache.org/dist/zookeeper/$DISTRO_NAME/$DISTRO_NAME.tar.gz"; \
    wget --quiet "http://www.apache.org/dist/zookeeper/$DISTRO_NAME/$DISTRO_NAME.tar.gz.asc"; \
    export GNUPGHOME="$(mktemp -d)"; \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-key "$GPG_KEY" || \
    gpg --keyserver pgp.mit.edu --recv-keys "$GPG_KEY" || \
    gpg --keyserver keyserver.pgp.com --recv-keys "$GPG_KEY"; \
    gpg --batch --verify "$DISTRO_NAME.tar.gz.asc" "$DISTRO_NAME.tar.gz"; \
    cd /; tar -xzf "$DISTRO_NAME.tar.gz"; \
    rm -rf "$GNUPGHOME" "$DISTRO_NAME.tar.gz" "$DISTRO_NAME.tar.gz.asc"; \
    mkdir -p "`dirname ${ZOO_BASE_DIR}`"; \
    mv "${DISTRO_NAME}" "${ZOO_BASE_DIR}";
    #apt-get remove -y --purge gnupg;

RUN mkdir -p "${ZOO_DATA_DIR}" "${ZOO_DATA_LOG_DIR}" "${ZOO_CONF_DIR}"

ADD zk-srv.sh /usr/bin
ADD log4j.properties ${ZOO_CONF_DIR}/log4j.properties
ADD zookeeper.properties.tmpl ${ZOO_CONF_DIR}

RUN chown -R docker:docker "${ZOO_BASE_DIR}" "${ZOO_DATA_DIR}" "${ZOO_DATA_LOG_DIR}" "${ZOO_CONF_DIR}" \
    && chmod +x /usr/bin/zk-srv.sh

WORKDIR "${ZOO_BASE_DIR}"
VOLUME ["${ZOO_DATA_DIR}", "${ZOO_DATA_LOG_DIR}"]

# client port: 2181/TCP
# peer-connection port: 2888/TCP
# leader election port: 3888/TCP
EXPOSE 2181 2888 3888

USER docker
ENTRYPOINT [ "/usr/bin/zk-srv.sh" ]