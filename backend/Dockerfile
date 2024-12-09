
FROM node:18

WORKDIR /app

COPY package*.json ./

# Install dependencies
RUN npm install

COPY server.ts tsconfig.json ./
COPY ./src ./src
COPY studybuds-firebase.json ./studybuds-firebase.json

EXPOSE 3000

CMD ["npx","ts-node-transpile-only", "server"]
