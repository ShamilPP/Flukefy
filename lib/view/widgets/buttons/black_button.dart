import 'package:flutter/material.dart';

import '../../../utils/colors.dart';

class BlackButton extends StatelessWidget {
  final String title;
  final void Function() onPressed;
  final double fontSize;

  const BlackButton({Key? key, required this.title, required this.onPressed, this.fontSize = 16}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
        padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(vertical: 15, horizontal: 20)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(fontSize: fontSize),
      ),
    );
  }
}
