import { Router } from 'express';
import { UserController } from '../../user/userController/user.controller';
import { authenticateJWT } from '../middleware/authMiddleware';


const router = Router();
const userController = new UserController();

router.post('/signup', (req, res) => userController.create(req, res));
router.post('/login', (req, res) => userController.login(req, res));
router.get('/profile/:id', authenticateJWT, (req, res) => userController.getProfile(req, res));
router.put('/profile/:id', authenticateJWT, (req, res) => userController.updateProfile(req, res));

export default router;