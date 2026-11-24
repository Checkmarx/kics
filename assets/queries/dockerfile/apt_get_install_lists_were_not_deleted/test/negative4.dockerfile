FROM busyboxneg5
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y python \
  && rm -rf /var/lib/apt/lists/*
