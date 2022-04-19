FROM busybox5
RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends package=0.0.0
