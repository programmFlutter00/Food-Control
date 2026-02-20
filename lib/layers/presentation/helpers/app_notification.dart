import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

class InAppNotification {
  static void showError(BuildContext context, String message) {
    Flushbar(
      padding: EdgeInsets.all(20),
      messageText: Text(
        message,
        style: TextStyle(
          // color: Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      duration: Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: Colors.white,

      flushbarStyle: FlushbarStyle.FLOATING, // 🔹 bu juda muhim
      margin: EdgeInsets.symmetric(horizontal: 14), // ekran atrofida bo‘sh joy
      borderRadius: BorderRadius.circular(12),
      borderColor: Colors.red,
      borderWidth: 1,
     
      icon: Icon(Icons.error, color: Colors.red),
      isDismissible: true,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      shouldIconPulse: false,

    ).show(context);
  }

  // Success notification
  static void showSuccess(BuildContext context, String message) {
 Flushbar(
      padding: EdgeInsets.all(20),
      messageText: Text(
        message,
        style: TextStyle(
          // color: Colors.green,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      duration: Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: Colors.white,

      flushbarStyle: FlushbarStyle.FLOATING, // 🔹 bu juda muhim
      margin: EdgeInsets.symmetric(horizontal: 14), // ekran atrofida bo‘sh joy
      borderRadius: BorderRadius.circular(12),
      borderColor: Colors.green,
      borderWidth: 1,
     
      icon: Icon(Icons.check_circle_outline_outlined, color: Colors.green),
    ).show(context);
 
  }

  // Warning / info notification
  static void showInfo(BuildContext context, String message) {
    Flushbar(
      title: "Ma'lumot ℹ️",
      message: message,
      duration: Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: Colors.blue,
      icon: Icon(Icons.info, color: Colors.white),
    ).show(context);
  }
}
