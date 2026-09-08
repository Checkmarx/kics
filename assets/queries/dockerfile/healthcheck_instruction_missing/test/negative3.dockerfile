from node:alpine
workdir /usr/src/app
copy package*.json ./
run npm install
copy . .
expose 3000
healthcheck CMD curl --fail http://localhost:3000 || exit 1 
cmd ["node","app.js"]