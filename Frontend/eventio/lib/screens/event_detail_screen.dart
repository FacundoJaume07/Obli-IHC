import 'package:eventio/models/event.dart';
import 'package:flutter/material.dart';
import '../services/event_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../routes/app_routes.dart';

class EventDetailScreen extends StatefulWidget {
  final String eventId;
  const EventDetailScreen({super.key, required this.eventId});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  Event? eventData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEvent();
  }

  Future<void> _loadEvent() async {
    final data = await EventService.getEventById(widget.eventId);
    print ("Loading event with ID: ${widget.eventId}");
    print("Event data: ${data}");
    setState(() {
      eventData = data;
      print("Event data loaded: ${eventData}");
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Event details'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : eventData == null
              ? const Center(child: Text('Event not found'))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Imagen del evento
                        Container(
                          height: 220,
                          margin: const EdgeInsets.only(bottom: 28),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: eventData!.image64 != null
                              ? (eventData!.image64.toString().startsWith('http')
                                  ? Image.network(
                                      eventData!.image64,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    )
                                  : Image.asset(
                                      eventData!.image64,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ))
                              : const Center(child: Text('No image')),
                        ),
                        Text(
                          eventData!.title ?? 'Sin título',
                          style: const TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 14),
                        Text(eventData != null ?  
                          eventData!.date.toString()
                          : 'Fecha no disponible',
                            style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 18, color: Colors.blueAccent),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                eventData != null ?
                                eventData!.location 
                                : 'Sin ubicación',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        const Text(
                          'About the event',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(eventData != null ? 
                            eventData!.description
                            : 'Sin descripción disponible.',
                            style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 28),
                        Row(
                          children: const [
                            Text('Add to list', style: TextStyle(fontSize: 16)),
                            SizedBox(width: 8),
                            Icon(Icons.calendar_today, size: 18),
                          ],
                        ),
                        const SizedBox(height: 18),
                        const Text('Add Review', style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 28),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: CustomButton(
                                text: 'Register',
                                onPressed: () {
                                  // TODO: Implement registration action
                                },
                              ),
                            ),
                            const SizedBox(width: 18),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  // TODO: Implement share action
                                },
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  side: const BorderSide(color: Color(0xFF12BDED)),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                ),
                                child: const Text('Share'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 0),
    );
  }
}