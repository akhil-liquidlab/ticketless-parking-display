import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:ticketless_parking_display/providers/screen_provider.dart';
import 'package:ticketless_parking_display/widgets/custom_text.dart';
import 'package:ticketless_parking_display/screens/config_screen.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({super.key});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  Timer? timer;
  initiate() {
    timer = Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        Provider.of<ScreenProvider>(context, listen: false).updateCurrentTime();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    initiate();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ScreenProvider>(builder: (context, screenProvider, child) {
      return Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(text: "Hi, people"),
                ],
              ),
              SizedBox(height: 10),
              CustomText(
                text: DateFormat("hh:mm:ss aa")
                    .format(screenProvider.currentTime),
                size: 140,
                weight: FontWeight.bold,
              ),
              SizedBox(
                width: 600,
                child: Lottie.asset("assets/lottie/car_on_road.json"),
              ),
            ],
          ),
          Positioned(
            top: 20,
            right: 20,
            child: IconButton(
              icon: Icon(Icons.settings, size: 32),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ),
        ],
      );
    });
  }
}
