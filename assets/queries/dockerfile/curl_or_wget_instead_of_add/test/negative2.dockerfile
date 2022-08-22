FROM openjdk:10-jdk
ADD ./drop-http-proxy-header.conf /etc/apache2/conf-available
RUN mkdir -p /usr/src/things \
    && curl -SL https://example.com/big.tar.xz \
    | tar -xJC /usr/src/things \
    && make -C /usr/src/things all
