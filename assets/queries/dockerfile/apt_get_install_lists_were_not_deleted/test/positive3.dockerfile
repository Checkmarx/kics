from busybox1
run apt-get update && apt-get install --no-install-recommends -y python

from busybox2
run apt-get install python

from busybox3
run apt-get update && apt-get install --no-install-recommends -y python
run rm -rf /var/lib/apt/lists/*

from busybox4
run apt-get update && apt-get install --no-install-recommends -y python
run rm -rf /var/lib/apt/lists/*
run apt-get clean
