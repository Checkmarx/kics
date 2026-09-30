from opensuse/leap:15.2
run zypper install -y httpd && zypper clean
run ["zypper", "install", "http"]
healthcheck CMD curl --fail http://localhost:3000 || exit 1
