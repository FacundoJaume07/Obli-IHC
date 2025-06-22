import 'dart:async';

import 'package:eventio/helpers/widget_helper.dart';
import 'package:eventio/models/event.dart';
import 'package:eventio/services/event_service.dart';
import 'package:eventio/widgets/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class ExploreEventsScreen extends StatefulWidget {
  final String? initialTab;
  const ExploreEventsScreen({Key? key, this.initialTab}) : super(key: key);

  @override
  State<ExploreEventsScreen> createState() => _ExploreEventsState();
}

class _ExploreEventsState extends State<ExploreEventsScreen> {
  List<Event> _events = [];
  bool _isLoading = true;
  String activeTab = "All";
  Timer? _debounce;

  final List<String> tabs = ["All", "Concerts", "Theater", "Food", "Gallery", "Festival", "Sports", "Museums"];

  @override
  void initState() {
    super.initState();
    if (widget.initialTab != null && tabs.contains(widget.initialTab)) {
      print("Initial tab set to: ${widget.initialTab}");
      activeTab = widget.initialTab!;
    }
    _fetchEvents(null);
  }

  Future<void> _fetchEvents(String? searchTerm) async {
    try {
      setState(() => _isLoading = true);
      int? category;
      if (activeTab.isNotEmpty) {
        if (activeTab.contains("Concert")) {
          category = 0; 
        } else if (activeTab.contains("Theater")) {
          category = 1;
        } else if (activeTab.contains("Food")) {
          category = 2;
        } else if (activeTab.contains("Gallery")) {
          category = 3;
        } else if (activeTab.contains("Festival")) {
          category = 4;
        } else if (activeTab.contains("Sports")){
          category = 5;
        } else if (activeTab.contains("Museums")) {
          category = 6;
        } else {
          category = null;
        }

      }
      final events = await EventService.getEvents(searchTerm, category);
      setState(() {
        _events = events;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> getEvents(String query) async {
    setState(() async {
      String searchTerm = query.toLowerCase();
      await _fetchEvents(searchTerm);
    });
  }

  void _onSearchChanged(String query) { //no funciona el debounce
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(seconds: 1), () async {
      await getEvents(query);
    });
  }
  
  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Explore events',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: tabs.map((tab) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          activeTab = tab;
                          _fetchEvents(null);
                        });
                      },
                      child: _buildTab(tab, isActive: activeTab == tab),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Popular Categories
            const Text(
              "Popular categories",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 32,
                runSpacing: 16,
                children: [
                  _buildCategoryImage("assets/concert.jpg", "Concerts"),
                  _buildCategoryImage("assets/theater.jpg", "Theater"),
                  _buildCategoryImage("assets/food.jpg", "Food"),
                  _buildCategoryImage("assets/gallery.jpg", "Gallery"),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Search Bar
            const Text(
              "Search for events",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                hintText: 'Search for events, artists, venues',
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: _onSearchChanged,
            ),
          SizedBox(height: 12),
              ..._events.map((event) => EventCardBuilder.buildEventCard(context, event)),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 0),
    );
  }

  Widget _buildTab(String label, {required bool isActive}) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.blue : Colors.grey,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        if (isActive)
          Container(
            margin: const EdgeInsets.only(top: 4),
            height: 2,
            width: 20,
            color: Colors.blue,
          )
      ],
    );
  }

  Widget _buildCategoryImage(String assetPath, String category) {
    return GestureDetector(
      onTap: () {
        setState(() {
          activeTab = category;
          _fetchEvents(null);
        });
      },
      child: ClipOval(
        child: Image.asset(
          assetPath,
          width: 150,
          height: 150,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

