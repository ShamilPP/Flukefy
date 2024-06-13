import 'package:flukefy/utils/colors.dart';
import 'package:flukefy/view/screens/profile/profile_screen.dart';
import 'package:flukefy/view/widgets/appbar/curved_appbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../about/about_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CurvedAppBar(title: 'Settings'),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Account'),
            leading: Icon(Icons.account_circle, color: Colors.grey.shade600),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
            },
          ),
          const Divider(color: AppColors.dividerColor),
          ListTile(
            title: const Text('Notifications'),
            leading: Icon(Icons.notifications, color: Colors.grey.shade600),
            onTap: () {
              Fluttertoast.showToast(msg: 'Coming soon');
            },
          ),
          const Divider(color: AppColors.dividerColor),
          ListTile(
            title: const Text('Privacy'),
            leading: Icon(Icons.privacy_tip, color: Colors.grey.shade600),
            onTap: () {
              Fluttertoast.showToast(msg: 'Coming soon');
            },
          ),
          const Divider(color: AppColors.dividerColor),
          ListTile(
            title: const Text('About'),
            leading: Icon(Icons.info, color: Colors.grey.shade600),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutScreen()));
            },
          ),
        ],
      ),
    );
  }
}
