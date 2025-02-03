import 'package:get_it/get_it.dart';
import 'package:ticketless_parking_display/data/socket.dart';

var sl = GetIt.instance;

initializeServiceLocator() {
  sl.registerSingleton<SocketService>(SocketService());
}
