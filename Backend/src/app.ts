import express from 'express';
import cors from 'cors'; 
import dotenv from 'dotenv';
import userRoutes from './utils/router/user.routes';
import eventRoutes from './utils/router/event.routes';
dotenv.config();

import { dbSync } from './utils/config/database';
const app = express();
const PORT = process.env.PORT || 3000;

export const main = async () => {
  console.log("Starting server...");
  await dbSync();

  app.use(cors()); 
  app.use(express.json());
  app.use("/api", userRoutes);
  app.use("/api", eventRoutes);


  app.listen(PORT, async () => {
    console.log(`🚀 Server running at http://localhost:${PORT}`);
  });

}

main()