from openjdk:10-jdk
volume /tmp
add https://example.com/big.tar.xz /usr/src/things/
run tar -xJf /usr/src/things/big.tar.xz -C /usr/src/things
run make -C /usr/src/things all
