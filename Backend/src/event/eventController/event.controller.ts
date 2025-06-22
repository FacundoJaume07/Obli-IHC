import { Request, Response } from "express";
import { EventService } from "../eventService/event.service";

export class EventController {
    eventService: EventService;

    constructor() {
        this.eventService = new EventService();
    }


    getEvents = async (req: Request, res: Response) => {
        try {
            const filters = {
                search: req.query.search as string | undefined,
                category: req.query.category as number | undefined,
            };
            console.log('Filters received:', filters);
            const events = await this.eventService.getAllEvents(filters);
            console.log('Fetched events:', events);
            res.status(200).send(JSON.stringify(events));
        } catch (error: any) {
            console.error('Error fetching events:', error);
            res.status(500).json({ error: 'Something went wrong.' });
        }   
    }

    getById = async (req: Request, res: Response) => {
        const eventId = req.params.id;
        try {
            const event = await this.eventService.getEventById(eventId);
            if (!event) {
                res.status(404).json({ error: 'Event not found.' });
                return;
            }
            res.status(200).send(JSON.stringify(event));
        } catch (error: any) {
            console.error('Error fetching event:', error);
            res.status(500).json({ error: 'Something went wrong.' });
        }
    }

}