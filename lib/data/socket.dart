import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:ticketless_parking_display/providers/screen_provider.dart';
import 'package:ticketless_parking_display/providers/config_provider.dart';
import 'package:ticketless_parking_display/utils/enums.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

class SocketService {
  io.Socket? socket;
  static const int RECONNECT_INTERVAL = 5000;
  static const int MAX_RECONNECT_ATTEMPTS = 10;
  bool isConnecting = false;

  Future<void> initialize(BuildContext context) async {
    try {
      if (isConnecting) return;
      isConnecting = true;
      log('🔄 Initializing socket connection...');

      socket = io.io(
          "wss://sandbox.liquidlab.in",
          io.OptionBuilder()
              .setTransports(['websocket'])
              .enableForceNew()
              .enableReconnection()
              .setReconnectionAttempts(MAX_RECONNECT_ATTEMPTS)
              .setReconnectionDelay(RECONNECT_INTERVAL)
              .build());

      // Connection monitoring
      socket?.onConnect((_) {
        log('✅ Socket connected successfully');
        _registerDevice(context);
      });

      socket?.onConnectError((err) {
        log('❌ Socket connection error: $err');
        _handleReconnect(context);
      });

      socket?.onDisconnect((_) {
        log('⚠️ Socket disconnected');
        _handleReconnect(context);
      });

      socket?.onError((err) {
        log('🔥 Socket error: $err');
        _handleReconnect(context);
      });

      // Setup event listeners
      _setupEventListeners(context);

      socket?.connect();
      isConnecting = false;
    } catch (e) {
      isConnecting = false;
      log('🔥 Exception in socket connection: $e');
      _handleReconnect(context);
    }
  }

  void _registerDevice(BuildContext context) {
    final deviceId =
        Provider.of<ConfigProvider>(context, listen: false).deviceId;
    if (deviceId.isNotEmpty) {
      socket?.emit("register_device", [deviceId]);
      log('📱 Device registered with ID: $deviceId');
    }
  }

  void _setupEventListeners(BuildContext context) {
    socket?.on('event', (data) {
      log('📢 Event: $data');
      _updateScreenState(context, ScreenDataType.QUOTE, data.toString());
    });

    socket?.on('error', (data) {
      log('❌ Error event: $data');
      _updateScreenState(context, ScreenDataType.ERROR, data.toString());
    });

    socket?.on('failed', (data) {
      log('⚠️ Failed event: $data');
      _updateScreenState(context, ScreenDataType.FAILED, data.toString());
    });

    socket?.on('success', (data) {
      log('✅ Success event: $data');
      _updateScreenState(context, ScreenDataType.SUCCESS, data.toString());
    });

    socket?.on('welcome', (data) {
      log('👋 Welcome event: $data');
      _updateScreenState(
          context, ScreenDataType.CONNECTION_MSG, data.toString());
    });
  }

  void _updateScreenState(
      BuildContext context, ScreenDataType type, String message) {
    if (context.mounted) {
      Provider.of<ScreenProvider>(context, listen: false)
          .setScreenDataType(type, message: message, resetAfterTimer: true);
    }
  }

  Future<void> _handleReconnect(BuildContext context) async {
    if (!isConnecting) {
      log('🔄 Attempting to reconnect...');
      await Future.delayed(Duration(milliseconds: RECONNECT_INTERVAL));
      initialize(context);
    }
  }

  void disconnect() {
    socket?.disconnect();
    socket?.dispose();
    socket = null;
    isConnecting = false;
  }
}
