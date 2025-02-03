import 'package:flutter/material.dart';
import 'package:ticketless_parking_display/constants/const.dart';
import 'package:ticketless_parking_display/utils/enums.dart';

class ScreenProvider extends ChangeNotifier {
  // state data
  DateTime currentTime = DateTime.now();
  String title = '';
  String message = '';
  BarrierStatus barrierStatus = BarrierStatus.CLOSED;
  ScreenDataType screenDataType = ScreenDataType.TIMER;

  updateCurrentTime() {
    currentTime = DateTime.now();
    notifyListeners();
  }

  setScreenDataType(ScreenDataType type,
      {String? title,
      String? message,
      BarrierStatus? barrierStatus,
      bool resetAfterTimer = false}) async {
    screenDataType = type;
    if (title != null) {
      this.title = title;
    }
    if (message != null) {
      this.message = message;
    }
    if (barrierStatus != null) {
      this.barrierStatus = barrierStatus;
    }
    notifyListeners();
    if (resetAfterTimer) {
      await Future.delayed(Duration(seconds: AppConstants.delayInSeconds));
      resetToTimer();
    }
  }

  resetToTimer() {
    title = '';
    message = '';
    barrierStatus = BarrierStatus.CLOSED;
    screenDataType = ScreenDataType.TIMER;
    notifyListeners();
  }
}
