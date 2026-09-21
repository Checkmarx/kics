from busybox:1.0
run apt-get install curl
healthcheck CMD curl --fail http://localhost:3000 || exit 1 
