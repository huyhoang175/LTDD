// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';

class MyMessageHandler {
  static void showSnackBar(_scaffoldKey, String message) {
    _scaffoldKey.currentState!.hideCurrentSnackBar();
    _scaffoldKey.currentState!.showSnackBar(SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.yellow,
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        )));
  }
}
