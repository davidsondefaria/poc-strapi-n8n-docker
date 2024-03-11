FROM node:18-alpine as base

WORKDIR /home/node

EXPOSE 1337

USER node

COPY --chown=node . .

###########
### DEV ###
###########

FROM base as dev

RUN yarn --immutable --prefer-offline

CMD [ "yarn", "develop" ]

#############
### CLOUD ###
#############

FROM base as cloud

RUN yarn --immutable --prefer-offline --production

RUN yarn build

CMD [ "ash", "-c", "yarn && yarn start" ]