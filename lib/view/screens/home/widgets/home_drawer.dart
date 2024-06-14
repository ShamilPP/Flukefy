import 'package:flukefy/utils/app_details.dart';
import 'package:flukefy/view/screens/about/about_screen.dart';
import 'package:flukefy/view/screens/profile/profile_screen.dart';
import 'package:flukefy/view/screens/settings/settings_screen.dart';
import 'package:flukefy/view_model/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../orders/orders_screen.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({Key? key}) : super(key: key);

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context, listen: false).user;
    return Drawer(
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
            },
            child: Stack(
              children: [
                DrawerHeader(
                  child: Center(
                    child: Column(
                      children: [
                        // User profile photo
                        Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(color: Colors.blue.shade900, borderRadius: BorderRadius.circular(50)),
                          child: Center(
                              child: Text(
                            user!.name[0],
                            style: const TextStyle(color: Colors.white, fontSize: 30, fontFamily: 'roboto'),
                          )),
                        ),
                        const SizedBox(height: 10),
                        Text(user.name),
                      ],
                    ),
                  ),
                ),
                const Positioned(
                  bottom: 20,
                  right: 20,
                  child: Text('View profile', style: TextStyle(color: Colors.blue)),
                )
              ],
            ),
          ),
          drawerCard(title: 'Home', color: Colors.grey[300], onTap: () {}),
          drawerCard(
              title: 'Orders',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const OrdersScreen()));
              }),
          drawerCard(
              title: 'Settings',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
              }),
          drawerCard(
              title: 'About',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutScreen()));
              }),
          const Spacer(),
          const Text(AppDetails.appName, style: TextStyle(color: Colors.grey)),
          const Text('Version ${AppDetails.version}', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

Widget drawerCard({required String title, Color? color, required void Function() onTap}) {
  return InkWell(
    onTap: onTap,
    child: ListTile(
      title: Text(title),
      tileColor: color,
    ),
  );
}
