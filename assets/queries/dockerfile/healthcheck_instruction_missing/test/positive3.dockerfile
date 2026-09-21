from node:alpine
workdir /usr/src/app
copy package*.json ./
run npm install
copy . .
expose 3000
cmd ["node","app.js"]