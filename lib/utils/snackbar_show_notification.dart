import 'package:flutter/material.dart';

class notificationSnackbar {
  static void showSnackBar(context,text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: Duration(seconds: 3),
      ),
    );
  }
}
