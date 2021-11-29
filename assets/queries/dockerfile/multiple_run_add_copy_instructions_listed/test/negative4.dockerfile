FROM ubuntu
COPY README.md ./one
COPY package.json ./two
COPY gulpfile.js ./three
COPY __BUILD_NUMBER ./four

FROM ubuntu:1.2
ADD README.md ./one
ADD package.json ./two
ADD gulpfile.js ./three
ADD __BUILD_NUMBER ./four
