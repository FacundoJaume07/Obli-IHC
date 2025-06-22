import 'package:dio/dio.dart';
import '../config/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static final Dio _dio = Dio();

  static Future<Map<String, dynamic>?> getProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      final userToken = prefs.getString('userToken');
      if (userId == null) return null;

      final response = await _dio.get(
        '${AppConfig.apiBaseUrl}/profile/$userId',
        options: Options(
          headers: {
            if (userToken != null) 'Authorization': 'Bearer $userToken',
          },
        ),
      );
      if (response.statusCode == 200) {
        return response.data;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> updateProfile({
    required String name,
    required String email,
    required String bio,
    required String imageUrl,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      final userToken = prefs.getString('userToken');
      if (userId == null) return false;

      final response = await _dio.put(
        '${AppConfig.apiBaseUrl}/profile/$userId',
        data: {
          'name': name,
          'email': email,
          'bio': bio,
          'imageUrl': imageUrl,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (userToken != null) 'Authorization': 'Bearer $userToken',
          },
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
