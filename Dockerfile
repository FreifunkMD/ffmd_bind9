FROM debian:buster AS install

ARG GITREPO
ARG GITREF=master

# Apt-proxy config
COPY detect-apt-proxy.sh /usr/local/bin/
COPY 01proxy /etc/apt/apt.conf.d

# Keep apt cache directories!
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    git

RUN git clone $GITREPO /tmp/bind
RUN cd /tmp/bind && git checkout $GITREF

# Download bind9 for the next stage
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    --download-only \
    bind9


FROM debian:buster

LABEL maintainer="tux@md.freifunk.net"

COPY --from=install /var/lib/apt/lists/ /var/lib/apt/lists/
COPY --from=install /var/cache/apt/ /var/cache/apt/

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    bind9 \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/*

COPY --from=install /tmp/bind /etc/bind

EXPOSE 53/udp 53/tcp

CMD ["/usr/sbin/named", "-f"]
