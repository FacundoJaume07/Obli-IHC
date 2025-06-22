import { EventDto } from '../../utils/Entities/dtos/event.dto';
import { EventRepository } from '../eventRepository/event.repository';

export class EventService {
    eventRepository: EventRepository;

    constructor() {
        this.eventRepository = new EventRepository();
    }

    async getAllEvents(filters: { 
        search: string | undefined; 
        category?: number | undefined;
    }): Promise<EventDto[]> {
        return this.eventRepository.getAllEvents(filters);
    }
    
    
    async getEventById(eventId: string): Promise<EventDto | null> {
        return this.eventRepository.getEventById(eventId);
    }
}