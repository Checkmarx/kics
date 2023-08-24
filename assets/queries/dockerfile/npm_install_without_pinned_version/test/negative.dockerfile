FROM node:12
RUN npm install
RUN npm install sax@latest
RUN npm install sax@0.1.1
RUN npm install sax@0.1.1 | grep fail && npm install sax@latest
RUN npm install git://github.com/npm/cli.git
RUN npm install git+ssh://git@github.com:npm/cli#semver:^5.0
RUN npm install --production --no-cache
RUN npm install -g @commitlint/cli@17.4.4 @commitlint/config-conventional@17.4.4 @ionic/cli@6.18.0 @semantic-release/changelog@5.0.1 @semantic-release/git@9.0.0 @semantic-release/gitlab@6.2.1
RUN npm install -g @commitlint/cli@17.4.4 @commitlint/config-conventional@17.4.4 \
    @ionic/cli@6.18.0 @semantic-release/changelog@5.0.1 @semantic-release/git@9.0.0 @semantic-release/gitlab@6.2.1
