import 'package:flutter/material.dart';

import '../../../utils/colors.dart';

class CurvedDialog extends StatelessWidget {
  final String title;
  final double? height;
  final Widget? content;
  final Widget? button;
  final bool closeButton;

  const CurvedDialog({Key? key, required this.title, this.height, this.content, this.button, this.closeButton = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            // Content
            content == null
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: content!,
                  ),

            // Action buttons
            button == null
                ? const SizedBox()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      closeButton
                          ? TextButton(
                              child: const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              })
                          : const SizedBox(),
                      button!,
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
