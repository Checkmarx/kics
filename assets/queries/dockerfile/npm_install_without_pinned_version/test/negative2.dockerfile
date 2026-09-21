from node:12
run npm install
run npm install sax@latest
run npm install sax@0.1.1
run npm install sax@0.1.1 | grep fail && npm install sax@latest
run npm install git://github.com/npm/cli.git
run npm install git+ssh://git@github.com:npm/cli#semver:^5.0
run npm install --production --no-cache
run npm config set registry <internal_npm_registry> && \
    npm install && \
    npx vite build --mode $VITE_MODE