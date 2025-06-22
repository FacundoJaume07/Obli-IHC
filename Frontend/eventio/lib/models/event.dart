class Event {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final String image64;

  Event({required this.id, required this.title, required this.description, required this.date, required this.location, required this.image64});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date'] as String),
      location: json['location'],
      image64: json['image'],
    );
  }
}