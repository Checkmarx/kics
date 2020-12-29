FROM node:12
RUN npm install sax
RUN npm i -g @angular/cli
RUN ["npm","add","sax"]