import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EventsCard extends StatelessWidget {
  final Map<String, dynamic> event;
  const EventsCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_today),
              const SizedBox(width: 10),
              Text(
                event['campName'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.location_on),
              const SizedBox(width: 10),
              ElevatedButton(
                  onPressed: () {
                    if (event['latitude'] != null &&
                        event['longitude'] != null) {
                      final Uri googleMapsUrl = Uri.parse(
                          'https://www.google.com/maps/search/?api=1&query=${event['latitude']},${event['longitude']}');
                      launchUrl(googleMapsUrl);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Invalid coordinates.")),
                      );
                    }
                  },
                  child: Row(
                    children: [
                      Text('Find Route'),
                    ],
                  ))
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.access_time),
              const SizedBox(width: 10),
              Text(
                event['time'],
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.people),
              const SizedBox(width: 10),
              Text(
                event['organizer'],
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
