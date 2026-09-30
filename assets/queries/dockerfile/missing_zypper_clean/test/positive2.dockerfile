from busybox:1.0
run zypper install
healthcheck CMD curl --fail http://localhost:3000 || exit 1
