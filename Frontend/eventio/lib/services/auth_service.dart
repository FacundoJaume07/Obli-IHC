import 'dart:convert';
import 'package:dio/dio.dart';
import '../config/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final Dio _dio = Dio();

  static Future<bool> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      //log to console
      print('Signing up with name: $name, email: $email');
      final response = await _dio.post('${AppConfig.apiBaseUrl}/signup',
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final user = response.data['user'];
        final token = response.data['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', user['id'].toString());
        await prefs.setString('userEmail', user['email']);
        await prefs.setString('userToken', token);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error during signup: $e');
      return false;
    }
  }

  static Future<bool> login({
  required String email,
  required String password,
}) async {
  try {
    final response = await _dio.post(
      '${AppConfig.apiBaseUrl}/login',
      data: {
        'email': email,
        'password': password,
      },
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final user = response.data['user'];
      final token = response.data['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', user['id'].toString());
      await prefs.setString('userEmail', user['email']);
      await prefs.setString('userToken', token);
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}
}
