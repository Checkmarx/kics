FROM busyboxneg5
RUN apt-get update; \
  apt-get install --no-install-recommends -y python; \
  apt-get clean; \
  rm -rf /var/lib/apt/lists/*

FROM busyboxneg6
RUN apt-get update; \
  apt-get install --no-install-recommends -y python; \
  apt-get clean

FROM busyboxneg7
RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends package=0.0.0; \
	rm -rf /var/lib/apt/lists/*
