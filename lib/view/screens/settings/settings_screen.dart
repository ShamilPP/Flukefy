import 'package:flukefy/view/screens/profile/profile_screen.dart';
import 'package:flukefy/view/widgets/general/curved_appbar.dart';
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
            leading: const Icon(Icons.account_circle),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Notifications'),
            leading: const Icon(Icons.notifications),
            onTap: () {
              Fluttertoast.showToast(msg: 'Coming soon');
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Privacy'),
            leading: const Icon(Icons.privacy_tip),
            onTap: () {
              Fluttertoast.showToast(msg: 'Coming soon');
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('About'),
            leading: const Icon(Icons.info),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutScreen()));
            },
          ),
        ],
      ),
    );
  }
}
