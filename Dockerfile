# start with Alpine Linux Base image
# NOTE: change 'ARG IMG_VER="..."' statement to preferred Node.js image
ARG IMG_VER="10.15.3-alpine"
FROM node:${IMG_VER}
LABEL maintainer="Adam Eilers"

# NOTE: if user created, change APP_PATH to user's workspace
ARG APP_PATH="/opt/test"
ARG APP_SOURCE="test.tar.gz"
ARG NODE_ENV

# set environment variables
ENV NODE_ENV="${NODE_ENV:-production}" \
    DBUS_SESSION_BUS_ADDRESS=/dev/null

# Project code
# NOTE: APP_SOURCE can use build process compressed output for smaller production builds
ADD ${APP_SOURCE} ${APP_PATH}

# change to workspace and run project install script
WORKDIR ${APP_PATH}
RUN apk add --update --no-cache bash-completion && bash ./bin/install

# expose standard Node.js port of 3000
EXPOSE 9515

# NOTE: calls auto-test with default config
ENTRYPOINT ["dumb-init", "--"]
CMD ["npm", "start"]
