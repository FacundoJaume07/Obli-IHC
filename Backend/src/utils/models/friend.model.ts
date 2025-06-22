import { DataTypes } from 'sequelize';
import { sequelize } from '../config/database';
import User from './user.model';

const Friend = sequelize.define('Friend', {
  userId: {
    type: DataTypes.UUID,
    allowNull: false,
    references: {
      model: 'Users',
      key: 'id'
    }
  },
  friendId: {
    type: DataTypes.UUID,
    allowNull: false,
    references: {
      model: 'Users',
      key: 'id'
    }
  }
}, {
  tableName: 'Friends',
  timestamps: false
});

export default Friend;
