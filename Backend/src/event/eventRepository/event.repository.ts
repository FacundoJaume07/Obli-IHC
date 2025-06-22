import { EventDto } from "../../utils/Entities/dtos/event.dto";
import Event from "../../utils/models/event.model";
import { Op } from 'sequelize';

export class EventRepository {
    
    async getAllEvents(filters: { 
        search: string | undefined;
        category?: number | undefined;
    }): Promise<EventDto[]> {
        try {
            const where: any = {};

            if (filters.category) {
                where.category = filters.category;
            }
               
            if (filters.search) {
            const searchTerm = `%${filters.search}%`; // arma una wildcard para SQL
            where[Op.or] = [
                { title: { [Op.like]: searchTerm } },
                { description: { [Op.like]: searchTerm } },
                { location: { [Op.like]: searchTerm } }
            ];
        }

            const events = await Event.findAll({ where });
            return events.map(event => event.toJSON() as EventDto);
        } catch (error) {
            console.error('Error fetching events:', error);
            throw new Error('Failed to fetch events');
        }
    }

    async getEventById(eventId: string): Promise<EventDto | null> {
        try {
            const event = await Event.findByPk(eventId);
            if (!event) {
                return null;
            }
            return event.toJSON() as EventDto;
        } catch (error) {
            console.error('Error fetching event by ID:', error);
            throw new Error('Failed to fetch event by ID');
        }
    }
}