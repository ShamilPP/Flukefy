import 'package:flukefy/view/screens/profile/widgets/logout_button.dart';
import 'package:flukefy/view/screens/profile/widgets/profile_list_tile.dart';
import 'package:flukefy/view/widgets/general/curved_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../view_model/user_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context, listen: false).user;
    return Scaffold(
      appBar: const CurvedAppBar(title: 'Profile'),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  // User profile photo
                  Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(color: Colors.blue.shade900, borderRadius: BorderRadius.circular(50)),
                    child: Center(
                        child: Text(
                      user.name[0],
                      style: const TextStyle(color: Colors.white, fontSize: 40, fontFamily: 'roboto'),
                    )),
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
      ),
    );
  }
}
