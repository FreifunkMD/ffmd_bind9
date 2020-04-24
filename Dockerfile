FROM debian:buster-slim
LABEL maintainer="tux@md.freifunk.net"

RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    	bind9 \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/*

EXPOSE 53/udp 53/tcp

CMD ["/usr/sbin/named", "-f", "-g"]
