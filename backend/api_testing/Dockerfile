FROM node:20.18.0-alpine3.19

WORKDIR /app/backend
COPY ./backend/package.json ./backend/package-lock.json /app/backend/
RUN npm install --omit=dev --no-package-lock
WORKDIR /app/test
COPY ./test/package.json ./test/package-lock.json /app/test/
RUN npm install --omit=dev --no-package-lock
WORKDIR /app/backend/api_testing
COPY ./backend/api_testing/package.json ./backend/api_testing/package-lock.json /app/backend/api_testing/
RUN npm install --omit=dev --no-package-lock
COPY ./backend/src /app/backend/src
COPY ./test/utils /app/test/utils
COPY ./backend/api_testing/test /app/backend/api_testing/test
ENTRYPOINT [ "npx","vitest","run","--no-file-parallelism" ]
CMD [""]
