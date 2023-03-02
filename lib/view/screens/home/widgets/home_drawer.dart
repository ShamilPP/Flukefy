import 'package:flukefy/utils/constant.dart';
import 'package:flukefy/view/screens/profile/profile_screen.dart';
import 'package:flukefy/view_model/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({Key? key}) : super(key: key);

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          InkWell(
            onTap: () {
              var user = Provider.of<UserProvider>(context, listen: false).user;
              Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen(user: user)));
            },
            child: Stack(
              children: [
                DrawerHeader(
                  child: Center(
                    child: Column(
                      children: [
                        const Icon(Icons.account_circle, color: Colors.grey, size: 80),
                        const SizedBox(height: 10),
                        Text(Provider.of<UserProvider>(context, listen: false).user.name),
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
              title: 'Profile',
              onTap: () {
                var user = Provider.of<UserProvider>(context, listen: false).user;
                Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen(user: user)));
              }),
          drawerCard(title: 'Settings', onTap: () {}),
          drawerCard(title: 'About', onTap: () {}),
          const Spacer(),
          const Text(appName, style: TextStyle(color: Colors.grey)),
          const Text('Version $version', style: TextStyle(color: Colors.grey)),
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
