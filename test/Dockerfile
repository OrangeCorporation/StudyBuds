FROM node:20.18.0-alpine3.19

WORKDIR /app/backend
COPY ./backend/package.json ./backend/package-lock.json /app/backend/
RUN npm install --omit=dev --no-package-lock
WORKDIR /app/test
COPY ./test/package.json ./test/package-lock.json /app/test/
RUN npm install --omit=dev --no-package-lock
COPY ./backend/src /app/backend/src
COPY ./test/tsconfig.json /app/test/tsconfig.json
COPY ./test/features /app/test/features
COPY ./test/utils /app/test/utils
COPY ./test/steps /app/test/steps
ENTRYPOINT [ "npx","cucumber-js","--require-module","ts-node/register","--require","steps/*.ts" ]
CMD []
