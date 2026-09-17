from busyboxneg1
run apt-get update && apt-get install --no-install-recommends -y python \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

from busyboxneg2
run apt-get update && apt-get install --no-install-recommends -y python && apt-get clean

from busyboxneg3
run apt-get update && apt-get install --no-install-recommends -y python \
  && apt-get clean

from busyboxneg4
run apt-get update && apt-get install --no-install-recommends -y python \
  && rm -rf /var/lib/apt/lists/*
