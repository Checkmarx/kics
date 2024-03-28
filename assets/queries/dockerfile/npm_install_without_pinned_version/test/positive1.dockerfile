FROM node:12
RUN npm install sax
RUN npm install sax --no-cache
RUN npm install sax | grep fail && npm install sax@latest
RUN npm install sax@latest | grep fail && npm install sax
RUN npm install sax | grep fail && npm install sax
RUN npm i -g @angular/cli
RUN ["npm","add","sax"]
