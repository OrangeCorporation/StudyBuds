FROM node:18-slim

WORKDIR /app

COPY package.json package-lock.json ./

# Install dependencies
RUN npm install --omit=dev --no-package-lock

COPY studybuds-116d5.json ./studybuds-116d5.json
COPY server.ts tsconfig.json ./
COPY ./src ./src

CMD ["npx","ts-node-transpile-only", "server"]
