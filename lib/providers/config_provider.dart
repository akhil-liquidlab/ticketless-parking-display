import 'package:flutter/material.dart';
import 'package:ticketless_parking_display/data/api.dart';
import 'package:ticketless_parking_display/data/local.dart';
import 'package:ticketless_parking_display/models/user_model.dart';
import 'dart:convert';

enum AuthState {
  initial,
  authenticating,
  authenticated,
  error,
}

class ConfigProvider extends ChangeNotifier {
  String _deviceId = '';
  AuthState _authState = AuthState.initial;
  UserModel? _user;
  String? _errorMessage;

  // Add constructor to load device ID immediately
  ConfigProvider() {
    _loadDeviceId();
  }

  // Add private method to load device ID
  Future<void> _loadDeviceId() async {
    final deviceId = await LocalStorageService.getString('device_id');
    if (deviceId != null && deviceId.isNotEmpty) {
      _deviceId = deviceId;
      notifyListeners();
    }
  }

  // Getters
  String get deviceId => _deviceId;
  AuthState get authState => _authState;
  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _authState == AuthState.authenticated;

  void updateDeviceId(String newId) {
    _deviceId = newId;
    LocalStorageService.setString(newId, 'device_id');
    notifyListeners();
  }

  Future<bool> authenticate(String username, String password) async {
    try {
      _authState = AuthState.authenticating;
      _errorMessage = null;
      notifyListeners();

      // Initialize services
      await APIServices.initialize();
      await LocalStorageService.initialize();

      final user = await APIServices.instance.login(username, password);

      if (user != null) {
        _user = user;
        _authState = AuthState.authenticated;

        // Store auth state
        await LocalStorageService.setString('true', 'is_authenticated');
        await LocalStorageService.setString(
            user.toJson().toString(), 'user_data');

        notifyListeners();
        return true;
      } else {
        _authState = AuthState.error;
        _errorMessage = 'Invalid credentials';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _authState = AuthState.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _authState = AuthState.initial;
    _user = null;
    _errorMessage = null;

    // Only clear auth-related storage
    LocalStorageService.setString('false', 'is_authenticated');
    LocalStorageService.setString('', 'user_data');

    notifyListeners();
  }

  // Update initializeAuth to not override existing device ID
  Future<void> initializeAuth() async {
    final isAuthenticated =
        await LocalStorageService.getString('is_authenticated');
    final userData = await LocalStorageService.getString('user_data');

    if (isAuthenticated == 'true' && userData != null) {
      try {
        _user = UserModel.fromJson(json.decode(userData));
        _authState = AuthState.authenticated;
        notifyListeners();
      } catch (e) {
        logout();
      }
    }
  }
}
