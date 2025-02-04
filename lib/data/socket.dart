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
    try {
      log('Attempting to connect to socket...');

      socket = io.io(
          "https://sandbox.liquidlab.in", // Use http or https, NOT ws://
          io.OptionBuilder()
              .setTransports(['websocket'])
              .enableForceNew()
              .setPath("/ticketless")
              .setReconnectionAttempts(3)
              .setReconnectionDelay(5000)
              .build());

      // Connection status logs
      socket.onConnect((_) => log('✅ Socket connected successfully'));
      socket.onConnectError((err) => log('❌ Socket connection error: $err'));
      socket.onDisconnect((_) => log('⚠️ Socket disconnected'));
      socket.onReconnect((_) => log('🔄 Socket reconnecting...'));

      socket.connect();
    } catch (e) {
      log('🔥 Exception in socket connection: $e');
      rethrow;
    }

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
