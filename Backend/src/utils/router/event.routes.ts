import { Router } from 'express';
import { EventController } from '../../event/eventController/event.controller';
import { authenticateJWT } from '../middleware/authMiddleware';

const router = Router();
const eventController = new EventController();

router.get('/events', authenticateJWT, (req, res) => eventController.getEvents(req, res));
router.get('/events/:id', authenticateJWT, (req, res) => eventController.getById(req, res));

export default router;