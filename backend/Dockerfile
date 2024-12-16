
FROM node:18

WORKDIR /app

COPY package*.json ./

# Install dependencies
RUN npm install

COPY server.ts tsconfig.json ./
COPY ./src ./src
COPY studybuds-116d5.json ./studybuds-116d5.json

CMD ["npx","ts-node-transpile-only", "server"]
