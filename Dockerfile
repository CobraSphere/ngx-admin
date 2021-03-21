# https://docs.docker.com/develop/develop-images/multistage-build/#stop-at-a-specific-build-stage
# https://docs.docker.com/compose/compose-file/#target


# https://docs.docker.com/engine/reference/builder/#understand-how-arg-and-from-interact
ARG NODE_VERSION=14

# "common" stage
FROM node:${NODE_VERSION}-alpine AS api_platform_admin_common

EXPOSE 3000

WORKDIR /usr/src/admin

ENV NEXT_TELEMETRY_DISABLED 1

# prevent the reinstallation of node modules at every changes in the source code
COPY package.json package-lock.json ./
RUN npm i

COPY . ./

VOLUME /usr/src/admin/node_modules


# "development" stage
# depends on the "common" stage above
FROM api_platform_admin_common AS api_platform_admin_dev

ENV API_PLATFORM_CLIENT_GENERATOR_OUTPUT .
RUN yarn global add @api-platform/client-generator

CMD ["npm", "dev"]


# "build" stage
# depends on the "common" stage above
FROM api_platform_admin_common AS api_platform_admin_prod

ENV NODE_ENV production
ARG REACT_APP_API_ENTRYPOINT

RUN set -eux; \
	npm run build:prod

CMD ["npm", "start"]
