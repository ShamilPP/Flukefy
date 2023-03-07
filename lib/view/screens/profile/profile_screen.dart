import 'package:flukefy/view/screens/profile/widgets/logout_button.dart';
import 'package:flukefy/view/screens/profile/widgets/profile_list_tile.dart';
import 'package:flukefy/view/widgets/general/curved_app_bar.dart';
import 'package:flutter/material.dart';

import '../../../model/user.dart';
import '../../../utils/colors.dart';
import '../../animations/slide_animation.dart';

class ProfileScreen extends StatelessWidget {
  final User user;

  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CurvedAppBar(title: 'Profile'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: [
                // User profile photo
                Center(
                  child: Stack(
                    children: [
                      const SlideAnimation(
                        delay: 200,
                        child: Icon(
                          Icons.account_circle,
                          size: 130,
                          color: Colors.grey,
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: SlideAnimation(
                          delay: 400,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 4,
                                color: Colors.white,
                              ),
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // User details
                ProfileListTile(text: user.name, subText: 'Name'),
                ProfileListTile(text: '+91 ${user.phone}', subText: 'Phone number'),
                ProfileListTile(text: user.email, subText: 'Email'),
              ],
            ),
          ),

          // Logout button
          const Padding(
            padding: EdgeInsets.only(top: 20, bottom: 10),
            child: Center(child: LogoutButton()),
          ),
        ],
      ),
    );
  }
}
