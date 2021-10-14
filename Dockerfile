FROM node:14-alpine as base

WORKDIR /usr/src/app

ENV HOST=0.0.0.0

COPY rollup.config.js ./
COPY package*.json ./

RUN npm install

COPY ./src ./src
COPY ./public ./public

#
# DEV
#
FROM base as dev

EXPOSE 5000
EXPOSE 35729

CMD ["npm", "run", "dev"]

#
# PROD
#
FROM base as prod

RUN npm run-script build

EXPOSE 5000

CMD [ "npm", "start" ]