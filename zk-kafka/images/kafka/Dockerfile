FROM pseudonymous/jre-base

LABEL maintainer="docker@pseudonymous.me"

ARG kafka_version=0.11.0.0
ARG scala_version=2.12

ENV DEBIAN_FRONTEND=noninteractive \
    KAFKA_VERSION=${kafka_version} \
    SCALA_VERSION=${scala_version} \
    KAFKA_DISTRO=kafka_"${scala_version}"-"${kafka_version}"
ENV KAFKA_HOME=/opt/"${KAFKA_DISTRO}" \
    KAFKA_LOGS="/tmp/kafka-logs"
ENV KAFKA_CONF="${KAFKA_HOME}/conf/"

#expose kafka port
EXPOSE 9092

RUN set -ex; \
    wget -q http://apache.mirrors.spacedump.net/kafka/"${KAFKA_VERSION}"/"${KAFKA_DISTRO}".tgz -O /tmp/"${KAFKA_DISTRO}".tgz; \
    tar xf /tmp/"${KAFKA_DISTRO}".tgz -C /opt; \
    rm /tmp/"${KAFKA_DISTRO}".tgz

ADD docker-entrypoint utils.sh /
ADD server.properties.tmpl "${KAFKA_CONF}/server.properties.tmpl"
RUN set -ex; \
    chmod 755 /docker-entrypoint; \
    chown -R docker:docker "${KAFKA_HOME}";

USER docker
RUN set -ex; \
    mkdir -p "${KAFKA_LOGS}";
    

VOLUME [ "${KAFKA_LOGS}" ]
WORKDIR "${KAFKA_HOME}"
ENTRYPOINT [ "/docker-entrypoint" ]