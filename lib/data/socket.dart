import 'dart:developer';

import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:ticketless_parking_display/providers/screen_provider.dart';
import 'package:ticketless_parking_display/providers/config_provider.dart';
import 'package:ticketless_parking_display/utils/enums.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

class SocketService {
  late io.Socket socket;

  Future<void> initialize(context) async {
    // await dotenv.load();
    socket = io.io("ws://localhost:3000",
        io.OptionBuilder().setTransports(['websocket']).build());

    // important. identifies the device uniquely
    socket.emit("register_device",
        [Provider.of<ConfigProvider>(context, listen: false).deviceId]);

    socket.onConnect(
      (data) {
        // log('socket connected');
      },
    );

    socket.on(
      'event',
      (data) {
        log(data.toString());
        Provider.of<ScreenProvider>(context, listen: false).setScreenDataType(
            ScreenDataType.QUOTE,
            message: data.toString(),
            resetAfterTimer: true);
      },
    );

    socket.on(
      'error',
      (data) {
        log(data.toString());
        Provider.of<ScreenProvider>(context, listen: false).setScreenDataType(
            ScreenDataType.ERROR,
            message: data.toString(),
            resetAfterTimer: true);
      },
    );

    socket.on(
      'failed',
      (data) {
        log(data.toString());
        Provider.of<ScreenProvider>(context, listen: false).setScreenDataType(
            ScreenDataType.FAILED,
            message: data.toString(),
            resetAfterTimer: true);
      },
    );

    socket.on(
      'success',
      (data) {
        log(data.toString());
        Provider.of<ScreenProvider>(context, listen: false).setScreenDataType(
            ScreenDataType.SUCCESS,
            message: data.toString(),
            resetAfterTimer: true);
      },
    );

    socket.on(
      'welcome',
      (data) {
        log(data.toString());
        Provider.of<ScreenProvider>(context, listen: false).setScreenDataType(
            ScreenDataType.CONNECTION_MSG,
            message: data.toString(),
            resetAfterTimer: true);
      },
    );

    socket.onDisconnect(
      (data) {
        // log('socket disconnected');
      },
    );
  }

  disconnect() {
    socket.disconnect();
  }
}
