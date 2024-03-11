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

# ARG FRONTEND_URL

# RUN test -n "$FRONTEND_URL" || (echo "FRONTEND_URL  is a required build arg" && false)

# RUN sed -i "s~http://localhost:3000~$FRONTEND_URL~"g config/sync/core-store.plugin_users-permissions_advanced.json

# ARG DEFAULT_MAIL_FROM

# RUN test -n "$DEFAULT_MAIL_FROM" || (echo "DEFAULT_MAIL_FROM  is a required build arg" && false)

# RUN sed -i "s/noreply@chatpromo.com.br/$DEFAULT_MAIL_FROM/"g config/sync/core-store.plugin_users-permissions_email.json

RUN yarn --immutable --prefer-offline --production

# RUN rm -rf ./tests

RUN yarn build

CMD [ "ash", "-c", "yarn cs:import -y && yarn start" ]