FROM node:carbon
COPY package.json yarn.lock my_app/

FROM node:carbon1
COPY package.json yarn.lock
