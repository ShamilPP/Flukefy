import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(String text, Color? backgroundColor) {
  Fluttertoast.showToast(
    // Return userDocId if login was successful
    msg: text,
    toastLength: Toast.LENGTH_SHORT,
    fontSize: 16.0,
    textColor: Colors.white,
    webPosition: "center",
    backgroundColor: backgroundColor,
  );
}
