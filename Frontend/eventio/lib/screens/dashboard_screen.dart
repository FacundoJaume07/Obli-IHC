import 'package:eventio/helpers/widget_helper.dart';
import 'package:eventio/models/event.dart';
import 'package:eventio/screens/categories.dart';
import 'package:eventio/services/auth_service.dart';
import 'package:eventio/services/event_service.dart';
import 'package:eventio/widgets/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
import '../routes/app_routes.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Event> _events = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    try {
      final events = await EventService.getEvents(null, null);
      setState(() {
        _events = events;
        print("Events: ${_events}");
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Eventio')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCategoryCard(context, "Festival", "Live Music Festival", 'assets/liveMusicFestivalCategory.png'),
                  _buildCategoryCard(context, "Gallery", "Art Show", 'assets/artExpositionsCategory.png'),
                  _buildCategoryCard(context, "Concerts", "Concerts", 'assets/concert.jpg'),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Popular Events",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 12),
            ..._events.map((event) => EventCardBuilder.buildEventCard(context, event)),
          ],
        ),
      ),
     bottomNavigationBar: CustomBottomNavBar(currentIndex: 0),
    );
  }
}

Widget _buildCategoryCard(BuildContext context, String category, title, String imagePath) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ExploreEventsScreen(initialTab: category),
        ),
      );
    },
    child: Container(
      width: 150,
      margin: EdgeInsets.only(right: 12),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(imagePath, height: 80, width: 150, fit: BoxFit.cover),
          ),
          SizedBox(height: 4),
          Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    ),
  );
}
