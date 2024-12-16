import express from 'express';
import admin from 'firebase-admin';
import sequelize from './src/config/database';
import { errorHandler } from './src/middlewares/error_handler';
import indexRouter from './src/routes/index';
import { getErrorMessage } from './src/utils/api_error';
import { FB_PKEY } from './src/config/secrets';
import { readFileSync } from 'fs';
import { initModels } from './src/models/init-models';


const app = express();

// Middleware
app.use(express.json());
app.use(express.urlencoded({ extended: false }));

// Mount all routes without "/api" prefix
app.use('/', indexRouter);

// Test database connection
sequelize.authenticate()
    .then(() => {
        console.log('Database connected successfully!');
        initModels(sequelize);
    })
    .catch((error) => {
        console.error('Unable to connect to the database:', getErrorMessage(error));
    });

// Error handling middleware
app.use(errorHandler)

// firebase notification configuration
if(FB_PKEY!=="test"){
    const serviceAccount:unknown = JSON.parse(readFileSync("./studybuds-116d5.json","utf8"))
    admin.initializeApp({
        credential: admin.credential.cert({"private_key": FB_PKEY, ...serviceAccount})
    });
}
else{
    console.warn("Missing firebase private key, disabling firebase functionalities");
}


// Start the server
const PORT = Number.parseInt(process.env["SERVER_PORT"]??"5000");
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
