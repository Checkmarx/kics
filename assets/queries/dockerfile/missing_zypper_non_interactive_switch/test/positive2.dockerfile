from busybox:1.0
run zypper install httpd && zypper clean
healthcheck CMD curl --fail http://localhost:3000 || exit 1
