import 'package:flukefy/view/animations/slide_animation.dart';
import 'package:flukefy/view/screens/profile/widgets/logout_button.dart';
import 'package:flukefy/view/screens/profile/widgets/profile_list_tile.dart';
import 'package:flukefy/view/widgets/appbar/curved_appbar.dart';
import 'package:flukefy/view/widgets/general/fill_remaining_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../view_model/user_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CurvedAppBar(title: 'Profile'),
      body: FillRemainingScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<UserProvider>(builder: (ctx, provider, child) {
                var user = provider.user;
                return Column(
                  children: [
                    // User profile photo
                    SlideAnimation(
                      delay: 200,
                      child: Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(color: Colors.blue.shade900, borderRadius: BorderRadius.circular(50)),
                        child: Center(
                            child: Text(
                          user?.name[0] ?? '',
                          style: const TextStyle(color: Colors.white, fontSize: 40, fontFamily: 'roboto'),
                        )),
                      ),
                    ),

                    // User details
                    ProfileListTile(text: user?.name ?? '', subText: 'Name'),
                    ProfileListTile(text: '+91 ${user?.phone ?? ''}', subText: 'Phone number'),
                    ProfileListTile(text: user?.email ?? '', subText: 'Email'),
                  ],
                );
              }),

              // Logout button
              const Center(child: SlideAnimation(delay: 800, child: LogoutButton())),
            ],
          ),
        ),
      ),
    );
  }
}
