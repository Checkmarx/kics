FROM busyboxneg1
RUN apt-get update && apt-get install --no-install-recommends -y python \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

FROM busyboxneg2
RUN apt-get update && apt-get install --no-install-recommends -y python && apt-get clean

FROM busyboxneg3
RUN apt-get update && apt-get install --no-install-recommends -y python \
  && apt-get clean

FROM busyboxneg4
RUN apt-get update && apt-get install --no-install-recommends -y python \
  && rm -rf /var/lib/apt/lists/*
