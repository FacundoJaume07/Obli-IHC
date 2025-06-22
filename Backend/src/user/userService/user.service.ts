import { Injectable } from '@nestjs/common';
import { UserRepository } from '../userRepository/user.repository';
import { CreateUserDto } from '../../utils/Entities/dtos/user.dto';
import { IUser } from '../../utils/Entities/user';
import * as bcrypt from 'bcrypt';

@Injectable()
export class UserService {
    userRepository: UserRepository;
    constructor() {
        this.userRepository = new UserRepository();
     }

    async createUser(createUserDto: CreateUserDto): Promise<IUser> {
        const hashedPassword = await bcrypt.hash(createUserDto.password, 10);
        const userToCreate = { ...createUserDto, password: hashedPassword };
        return this.userRepository.createUser(userToCreate);
    }

    async login(email: string, password: string): Promise<IUser> {
        const user = await this.userRepository.findByEmail(email);

        if (!user) {
            throw new Error('Invalid email or password.');
        }

        const isMatch = await bcrypt.compare(password, user.get('password'));
        if (!isMatch) {
            throw new Error('Invalid email or password.');
        }

        const { password: _, ...userData } = user.get({ plain: true });
        return userData as IUser;
    }

    async getProfileWithFriends(id: string): Promise<any> {
        return this.userRepository.findByIdWithFriends(id);
    }

    async updateProfile(id: string, updateData: any): Promise<any> {
        return this.userRepository.updateUserProfile(id, updateData);
    }
}