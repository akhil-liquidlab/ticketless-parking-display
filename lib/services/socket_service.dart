class SocketService {
  static SocketService? _instance;

  static Future<void> initialize() async {
    _instance = SocketService();
  }

  static SocketService get instance {
    if (_instance == null) {
      throw Exception('SocketService not initialized');
    }
    return _instance!;
  }
}
