import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:ticketless_parking_display/providers/screen_provider.dart';
import 'package:ticketless_parking_display/providers/config_provider.dart';
import 'package:ticketless_parking_display/utils/enums.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

class SocketService {
  static SocketService? _instance;
  io.Socket? socket;
  static const int RECONNECT_INTERVAL = 5000;
  static const int MAX_RECONNECT_ATTEMPTS = 10;
  bool isConnecting = false;

  // Private constructor
  SocketService._();

  // Singleton factory
  static SocketService get instance {
    _instance ??= SocketService._();
    return _instance!;
  }

  void _removeAllListeners() {
    socket?.off('event');
    socket?.off('error');
    socket?.off('failed');
    socket?.off('success');
    socket?.off('welcome');
    socket?.clearListeners();
  }

  // Service initialization (without context)
  Future<void> initializeService() async {
    try {
      await dotenv.load();
      if (isConnecting) return;
      isConnecting = true;
      log('🔄 Initializing socket service...');

      socket = io.io(
          dotenv.get('SOCKET_URL'),
          io.OptionBuilder()
              .setTransports(['websocket'])
              .enableForceNew()
              .enableReconnection()
              .setReconnectionAttempts(MAX_RECONNECT_ATTEMPTS)
              .setReconnectionDelay(RECONNECT_INTERVAL)
              // .setTimeout(20000)
              .setExtraHeaders({
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              })
              .build());

      socket?.on('ping', (_) {
        log('📍 Ping received');
        socket?.emit('pong');
      });

      socket?.on('pong', (_) {
        log('📍 Pong received');
      });

      socket?.onReconnect((_) {
        log('🔄 Socket reconnected');
      });

      socket?.onReconnectAttempt((attemptNumber) {
        log('🔄 Reconnection attempt $attemptNumber');
      });

      socket?.onAny((event, data) {
        log('🌐 Socket Event: $event, Data: $data');
      });

      socket?.connect();
      isConnecting = false;
    } catch (e) {
      isConnecting = false;
      log('🔥 Exception in socket service initialization: $e');
    }
  }

  // Initialize with context (for event handling)
  Future<void> initializeEvents(BuildContext context) async {
    _removeAllListeners();
    _setupEventListeners(context);

    socket?.onConnect((_) {
      log('✅ Socket connected successfully');
      log('🔑 Socket ID: ${socket?.id}');
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
  }

  void _registerDevice(BuildContext context) {
    final deviceId =
        Provider.of<ConfigProvider>(context, listen: false).deviceId;
    if (deviceId.isNotEmpty) {
      socket?.emit("register_device", [deviceId, "display"]);
      log('📱 Device registered with ID: $deviceId');
      log('🔑 Current Socket ID: ${socket?.id}');
    }
  }

  void _setupEventListeners(BuildContext context) {
    log('📢 Setting up event listeners');

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

    socket?.on('registration_success', (data) {
      log('✅ Registration Success: $data');
      _updateScreenState(
        context,
        ScreenDataType.REGISTRATION_SUCCESS,
        data.toString(),
      );
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
      log('🔑 Last Socket ID: ${socket?.id}');
      await Future.delayed(Duration(milliseconds: RECONNECT_INTERVAL));
      initializeEvents(context);
    }
  }

  void disconnect() {
    socket?.disconnect();
    socket?.dispose();
    socket = null;
    isConnecting = false;
  }
}
