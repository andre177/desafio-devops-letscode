FROM node:14.21.2-bullseye
RUN mkdir /opt/app
COPY app/ /opt/app
RUN npm install -g @angular/cli
WORKDIR /opt/app
EXPOSE 4200
CMD ["ng", "serve"]