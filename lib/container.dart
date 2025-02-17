import 'package:get_it/get_it.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ticketless_parking_display/data/api.dart';
import 'package:ticketless_parking_display/data/local.dart';
import 'package:ticketless_parking_display/data/socket.dart';
// import 'package:ticketless_parking_display/data/socket.dart';

var sl = GetIt.instance;

// initializeServiceLocator() {
//   sl.registerSingleton<SocketService>(SocketService());
// }

class ServiceContainer {
  static Future<void> initialize() async {
    await dotenv.load();
    await LocalStorageService.initialize();
    await APIServices.initialize();
    // await SocketService.instance
    //     .initializeService(); // New method for service-level init
  }
}
