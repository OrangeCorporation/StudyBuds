FROM node:18-slim

WORKDIR /app/backend
COPY ./backend/package.json ./backend/package-lock.json /app/backend/
RUN npm install --omit=dev --no-package-lock
COPY ./backend/tsconfig.json /app/backend/tsconfig.json
COPY ./test/utils /app/test/utils
COPY ./backend/src /app/backend/src
COPY ./backend/server_db/test_data/demo-data.ts /app/backend/server_db/test_data/demo-data.ts
ENTRYPOINT [ "npx","ts-node-transpile-only","server_db/test_data/demo-data" ]
CMD []
