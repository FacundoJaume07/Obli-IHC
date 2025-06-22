import { Request, Response } from "express";
import { UserService } from "../userService/user.service";
import { CreateUserDto } from "../../utils/Entities/dtos/user.dto";
import * as jwt from 'jsonwebtoken';


export class UserController {
    userService: UserService;
    constructor() {
        this.userService = new UserService();
     }

    async create(req: Request, res: Response): Promise<void> {
        const { name, email, password } = req.body;
        console.log('Creating user with data:', { name, email, password });
        try {
            if (!name || !email || !password) {
                res.status(400).json({ error: 'Name, email, and password are required.' });
                return;
            }

            const createUserDto = new CreateUserDto(name, email, password);
            const userData = await this.userService.createUser(createUserDto);
            const { password: _, ...userWithoutPassword } = userData;

            res.status(201).json(userWithoutPassword);
        } catch (error: any) {
            if (error.name === 'SequelizeUniqueConstraintError') {
                res.status(409).json({ error: 'Email already in use.' });
            } else {
                console.error('Error creating user:', error);
                res.status(500).json({ error: 'Something went wrong.' });
            }
        }
    }

    async login(req: Request, res: Response): Promise<void> {
        const { email, password } = req.body;

        try {
            if (!email || !password) {
                res.status(400).json({ error: 'Email and password are required.' });
                return;
            }

            const user = await this.userService.login(email, password);

            const jwtSecret = process.env.JWT_SECRET;

            const token = jwt.sign(
                { id: user.id, email: user.email }, 
                jwtSecret || 'default', 
                { expiresIn: '1h' }
            );

            res.status(200).json({ user: user, token: token });
        } catch (error: any) {
            console.error('Error during login:', error);
            if (error.message === 'Invalid email or password.') {
                res.status(401).json({ error: 'Invalid email or password.' });
            } else {
                res.status(500).json({ error: 'Something went wrong.' });
            }
        }
    }

    async getProfile(req: Request, res: Response): Promise<void> {
        const userId = req.params.id;
        try {
            const user = await this.userService.getProfileWithFriends(userId);
            if (!user) {
                res.status(404).json({ error: 'User not found.' });
                return;
            }

            res.status(200).json({
                name: user.name,
                email: user.email,
                bio: user.bio,
                imageUrl: user.imageUrl,
                attended: user.attended,
                reviews: user.reviews,
                lists: user.lists,
                friends: (user.Friends || []).map((f: any) => ({
                    imageUrl: f.imageUrl
                }))
            });
        } catch (error) {
            console.error('Error fetching profile:', error);
            res.status(500).json({ error: 'Something went wrong.' });
        }
    }

    async updateProfile(req: Request, res: Response): Promise<void> {
        const userId = req.params.id;
        const { name, email, bio, imageUrl } = req.body;
        try {
            const updatedUser = await this.userService.updateProfile(userId, { name, email, bio, imageUrl });
            res.status(200).json({
                name: updatedUser.name,
                email: updatedUser.email,
                bio: updatedUser.bio,
                imageUrl: updatedUser.imageUrl,
                attended: updatedUser.attended,
                reviews: updatedUser.reviews,
                lists: updatedUser.lists,
                friends: (updatedUser.Friends || []).map((f: any) => ({
                    imageUrl: f.imageUrl
                }))
            });
        } catch (error) {
            console.error('Error updating profile:', error);
            res.status(500).json({ error: 'Something went wrong.' });
        }
    }
}