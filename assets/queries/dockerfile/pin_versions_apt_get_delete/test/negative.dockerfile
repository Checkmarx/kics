FROM busybox
RUN apt-get update && apt-get install --no-install-recommends -y python \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*