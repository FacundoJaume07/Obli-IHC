export class EventDto {
    id?: string; // Optional ID for the event, can be used for database purposes
    title: string;
    date: Date;
    location?: string;
    description?: string;
    image?: string;
    category?: EventCategory;

    constructor(id:string, title: string, date: Date, description?: string, location?: string, image?: string, category?: EventCategory) {
        this.id = id;
        this.title = title;
        this.date = date;
        this.location = location;
        this.description = description;
        this.image = image;
        this.category = category;
    }
}

export enum EventCategory {
    Concert = 0,
    Theater = 1,
    Food = 2,
    Gallery = 3,
    Festival = 4,
    Sports = 5,
    Museum = 6,
}