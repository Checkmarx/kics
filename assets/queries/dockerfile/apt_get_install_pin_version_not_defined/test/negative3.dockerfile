FROM busybox
RUN apt-get install python=2.7 ; echo "A" && echo "B"