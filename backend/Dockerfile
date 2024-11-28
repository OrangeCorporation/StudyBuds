
FROM node:18

WORKDIR /app

COPY package*.json ./

# Install dependencies
RUN npm install

COPY server.ts tsconfig.json ./
COPY ./src ./src

EXPOSE 3000

CMD ["npx","ts-node", "server"]
