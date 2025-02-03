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
  @override
  void initState() {
    SocketService().initialize(context);
    super.initState();
  }

  @override
  void dispose() {
    SocketService().disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ScreenProvider>(builder: (context, screenProvider, child) {
        if (screenProvider.screenDataType == ScreenDataType.CONNECTION_MSG) {
          return Center(
            child: CustomText(
              text: screenProvider.message,
              alignCenter: true,
            ),
          );
        } else if (screenProvider.screenDataType == ScreenDataType.QUOTE) {
          return Center(
            child: CustomText(
              text: screenProvider.message,
              alignCenter: true,
            ),
          );
        } else if (screenProvider.screenDataType == ScreenDataType.ERROR) {
          return Center(
            child: CustomText(
              text: screenProvider.message,
              alignCenter: true,
            ),
          );
        } else if (screenProvider.screenDataType == ScreenDataType.FAILED) {
          return Center(
            child: CustomText(
              text: screenProvider.message,
              alignCenter: true,
            ),
          );
        } else if (screenProvider.screenDataType == ScreenDataType.SUCCESS) {
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
        }
        return Center(child: TimerWidget());
      }),
    );
  }

  void _navigateToConfig(BuildContext context) {
    final configProvider = Provider.of<ConfigProvider>(context, listen: false);
    if (configProvider.isAuthenticated) {
      Navigator.pushNamed(context, '/config');
    } else {
      Navigator.pushNamed(context, '/login');
    }
  }
}
