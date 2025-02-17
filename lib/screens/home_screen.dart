// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:ticketless_parking_display/data/socket.dart';
import 'package:ticketless_parking_display/providers/screen_provider.dart';
import 'package:ticketless_parking_display/utils/enums.dart';
import 'package:ticketless_parking_display/widgets/custom_text.dart';
import 'package:ticketless_parking_display/widgets/timer_widget.dart';
import 'package:ticketless_parking_display/providers/config_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool deviceConnectedToSocket = false;

  initializeSocket() async {
    await SocketService.instance.initializeService();
    SocketService.instance.initializeEvents(context);
  }

  @override
  void initState() {
    super.initState();

    initializeSocket();
  }

  @override
  void dispose() {
    SocketService.instance.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ScreenProvider>(builder: (context, screenProvider, child) {
        switch (screenProvider.screenDataType) {
          case ScreenDataType.CONNECTION_MSG:
            return Center(
              child: CustomText(
                text: screenProvider.message,
                alignCenter: true,
              ),
            );
          case ScreenDataType.REGISTRATION_SUCCESS:
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    screenProvider.screenDataType ==
                            ScreenDataType.REGISTRATION_SUCCESS
                        ? Icons.check_circle_outline
                        : Icons.info_outline,
                    size: 48,
                    color: Colors.green,
                  ),
                  SizedBox(height: 16),
                  CustomText(
                    text: screenProvider.message,
                    alignCenter: true,
                    size: 18,
                  ),
                ],
              ),
            );
          case ScreenDataType.QUOTE:
            return Center(
              child: CustomText(
                text: screenProvider.message,
                alignCenter: true,
              ),
            );
          case ScreenDataType.ERROR:
            return Center(
              child: CustomText(
                text: screenProvider.message,
                alignCenter: true,
              ),
            );
          case ScreenDataType.FAILED:
            return Center(
              child: CustomText(
                text: screenProvider.message,
                alignCenter: true,
              ),
            );
          case ScreenDataType.SUCCESS:
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: screenProvider.message,
                    alignCenter: true,
                  ),
                  Lottie.asset("assets/lottie/barrier_open.json")
                ],
              ),
            );
          default:
            return Center(child: TimerWidget());
        }
      }),
    );
  }

  void _navigateToConfig(BuildContext context) {
    final configProvider = Provider.of<ConfigProvider>(context, listen: false);
    if (configProvider.isAuthenticated) {
      Navigator.pushReplacementNamed(context, '/config');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
}
