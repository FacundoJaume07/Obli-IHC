import User from "../../utils/models/user.model";
import { CreateUserDto } from "../../utils/Entities/dtos/user.dto";


export class UserRepository {

    async createUser(createUserDTO: CreateUserDto): Promise<any> {
        return await User.create({
            name: createUserDTO.name,
            email: createUserDTO.email,
            password: createUserDTO.password,
        });
    }

    async findByEmail(email: string): Promise<any> {
        return await User.findOne({
            where: { email },
        });
    }

    async findByIdWithFriends(id: string): Promise<any> {
        return await User.findByPk(id, {
            attributes: ['id', 'name', 'email', 'bio', 'imageUrl', 'attended', 'reviews', 'lists'],
            include: [
                {
                    model: User,
                    as: 'Friends',
                    attributes: ['id', 'name', 'imageUrl'],
                    through: { attributes: [] }
                }
            ]
        });
    }

    async updateUserProfile(id: string, updateData: any): Promise<any> {
        await User.update(updateData, { where: { id } });
        return this.findByIdWithFriends(id);
    }
}