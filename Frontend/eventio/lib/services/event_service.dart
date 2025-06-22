import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:eventio/models/event.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';

class EventService {
  static final Dio _dio = Dio();

  static Future<List<Event>> getEvents(String? searchTerm, int? category) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userToken = prefs.getString('userToken');

      final response = await _dio.get(
        '${AppConfig.apiBaseUrl}/events',
        queryParameters: {
          if (searchTerm != null && searchTerm.isNotEmpty) 'search': searchTerm,
          if (category != null) 'category': category,
        },
        options: Options(
          headers: {
            if (userToken != null) 'Authorization': 'Bearer $userToken',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> jsonList = jsonDecode(response.data);
        final List<Event> events = jsonList.map((json) => Event.fromJson(json)).toList();
        print(events);
        return events;
      } else {
        print("error: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print('Error fetching events: $e');
      return [];
    }
  }
  
  static Future<Event?> getEventById(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userToken = prefs.getString('userToken');
      
      final response = await _dio.get(
        '${AppConfig.apiBaseUrl}/events/$id',
        options: Options(
          headers: {
            if (userToken != null) 'Authorization': 'Bearer $userToken',
          },
        ),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = jsonDecode(response.data);
        final Event event = Event.fromJson(jsonMap);
        return event;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}