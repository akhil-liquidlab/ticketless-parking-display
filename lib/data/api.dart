import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:ticketless_parking_display/models/user_model.dart';
import 'dart:developer';

class APIServices {
  static APIServices? _instance;

  static Future<void> initialize() async {
    await dotenv.load();
    _instance = APIServices();
    // Add any initialization logic here
  }

  static APIServices get instance {
    if (_instance == null) {
      throw Exception('APIServices not initialized');
    }
    return _instance!;
  }

  Future<UserModel?> login(String username, String password) async {
    try {
      print(dotenv.get('API_URL'));
      final response = await http.post(
        Uri.parse("${dotenv.get('API_URL')}/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password}),
      );

      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return UserModel.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      log('Login error: $e');
      rethrow;
    }
  }
}
