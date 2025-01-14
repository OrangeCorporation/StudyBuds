import { Sequelize } from 'sequelize';
import { getEnvironmentVariable } from '../utils/config_error';


// Create a Sequelize instance
const sequelize = new Sequelize(
    getEnvironmentVariable("DB_URL"),
    {
        // dialect: 'postgres', // PostgreSQL
        logging: console.log, // Enable query logging for debugging (optional)
    }
);

export default sequelize;
