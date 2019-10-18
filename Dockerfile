FROM debian:buster AS install

ARG GITREPO
ARG GITREF=master

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN git clone $GITREPO /tmp/bind
RUN cd /tmp/bind && git checkout $GITREF


FROM debian:buster

LABEL maintainer="tux@md.freifunk.net"

COPY --from=install /tmp/bind /etc/bind

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    bind9 \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 53/udp 53/tcp

CMD ["/usr/sbin/named"]
