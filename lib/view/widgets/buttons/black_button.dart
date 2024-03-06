import 'package:flutter/material.dart';

import '../../../utils/colors.dart';

class BlackButton extends StatelessWidget {
  final String title;
  final void Function() onPressed;
  final double fontSize;

  const BlackButton({super.key, required this.title, required this.onPressed, this.fontSize = 16});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      // style: ButtonStyle(
      //   backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
      //   foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      //   padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(vertical: 15, horizontal: 20)),
      //   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      //   ),
      // ),
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      ),
      child: Text(
        title,
        style: TextStyle(fontSize: fontSize),
      ),
    );
  }
}
