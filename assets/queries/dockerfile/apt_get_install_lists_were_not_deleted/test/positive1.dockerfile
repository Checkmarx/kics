FROM busybox1
RUN apt-get update && apt-get install --no-install-recommends -y python

FROM busybox2
RUN apt-get install python

FROM busybox3
RUN apt-get update && apt-get install --no-install-recommends -y python
RUN rm -rf /var/lib/apt/lists/*

FROM busybox4
RUN apt-get update && apt-get install --no-install-recommends -y python
RUN rm -rf /var/lib/apt/lists/*
RUN apt-get clean
