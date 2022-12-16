FROM node:14-alpine
RUN mkdir /opt/app
COPY app/ /opt/app
RUN npm install -g @angular/cli
WORKDIR /opt/app
EXPOSE 4200
CMD ["ng", "serve", "--host", "0.0.0.0", "--disable-host-check"]