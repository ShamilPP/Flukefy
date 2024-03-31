import 'package:flutter/material.dart';

import '../../../utils/colors.dart';

class CurvedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool backButton;
  final Widget? trailing;
  final bool elevation;

  const CurvedAppBar({Key? key, required this.title, this.backButton = true, this.trailing, this.elevation = true}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
        boxShadow: elevation
            ? [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ]
            : null,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Back button
              Positioned(
                left: 0,
                child: backButton
                    ? ClipOval(
                        child: Material(
                          color: primaryColor,
                          child: IconButton(
                            splashColor: Colors.grey,
                            icon: const Icon(
                              Icons.arrow_back_ios_new_sharp,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      )
                    : const SizedBox(),
              ),

              // Title
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),

              // Trailing (More options)
              Positioned(
                right: 0,
                child: trailing != null ? trailing! : const SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
