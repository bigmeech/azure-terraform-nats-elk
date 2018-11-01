FROM node:8.11.4-slim

RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y install python build-essential

ENV APP_HOME=/usr/src/app
ENV PUBLISHER_PORT=3000

RUN mkdir -p ${APP_HOME}
WORKDIR ${APP_HOME}

ARG NODE_ENV

COPY ./package.json ${APP_HOME}
COPY ./package-lock.json ${APP_HOME}
COPY ./process.yaml ${APP_HOME}
COPY ./src ${APP_HOME}/src

RUN npm install
RUN npm install pm2 -g

RUN apt-get -y remove python build-essential
RUN apt-get -y autoremove

EXPOSE ${PUBLISHER_PORT}
CMD [ "pm2-runtime","start", "process.yaml", "--json"]
