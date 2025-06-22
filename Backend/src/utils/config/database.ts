import dotenv from 'dotenv';
import { Sequelize } from 'sequelize';


dotenv.config();
console.log("Connecting to the database...", process.env.DB_NAME, process.env.DB_USER, process.env.DB_HOST, process.env.DB_PORT);
const sequelize = new Sequelize(
  process.env.DB_NAME!,
  process.env.DB_USER!,
  process.env.DB_PASS!,
  {
    host: process.env.DB_HOST,
    port: Number(process.env.DB_PORT) || 3306,
    dialect: 'mysql',
    logging: false,
  }
);

import User from '../models/user.model';
import Event from '../models/event.model';
import Friend from '../models/friend.model';

const setRelationships = () => {
  User.hasMany(Event, { foreignKey: 'userId'});
  // Relación de amigos (muchos a muchos)
  User.belongsToMany(User, {
    as: 'Friends',
    through: Friend,
    foreignKey: 'userId',
    otherKey: 'friendId'
  });
}

const syncEntities = async () => {
  await User.sync();
  await Event.sync();
  await Friend.sync();
}

const syncTables = async () => {
  try {
    await syncEntities();
    console.log("Tables synchronized successfully.");
  } catch (error) {   
    console.error("Error synchronizing tables:", error);
  }
}

const dbSync = async () => {
  await setRelationships();
  await syncTables();
};

export { sequelize,  dbSync};