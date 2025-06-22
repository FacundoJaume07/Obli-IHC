import 'package:eventio/models/event.dart';
import 'package:eventio/routes/app_routes.dart';
import 'package:flutter/material.dart';

class EventCardBuilder {
  static Widget buildEventCard(BuildContext context, Event event) {
  /*Uint8List imageBytes;
  print("Hello");
  try {
    // Handle both full data URI and plain base64
    final base64Data = base64Image.contains(',') ? base64Image.split(',').last : base64Image;
    print('Base64 data: ${base64Data}');
    imageBytes = base64Decode(base64Data);
  } catch (e) {
    // Fallback image in case of decoding error
    print('Error decoding base64 image: $e');
    imageBytes = Uint8List(0); // Empty image data
  }*/

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.eventDetails,
          arguments: event.id,
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(event.title,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 4),
                    Text(event.date.toString(), style: TextStyle(color: Colors.grey[600])),
                    SizedBox(height: 2),
                    Text(event.location, style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ),

              SizedBox(width: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: 
                  /*Image.memory(
                    imageBytes,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  )*/
                  Image.network(
                    event.image64,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}

