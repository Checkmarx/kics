from busybox:1.0
run zypper install -y httpd=2.4.46 && zypper clean
healthcheck CMD curl --fail http://localhost:3000 || exit 1
