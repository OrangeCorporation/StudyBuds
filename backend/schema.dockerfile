FROM node:18-slim

WORKDIR /app

COPY package.json package-lock.json ./

# Install dependencies
RUN npm install sequelize-auto pg pg-hstore --no-package-lock

COPY sequelize-auto-options.json ./

CMD ["/bin/sh","-c","npm exec -- sequelize-auto -h $POSTGRES_HOST -d $POSTGRES_DB -u $POSTGRES_USER -x $POSTGRES_PASSWORD -p $POSTGRES_PORT -o $OUT -c sequelize-auto-options.json"]
