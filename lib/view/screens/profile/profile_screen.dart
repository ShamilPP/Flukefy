import 'package:flukefy/view/widgets/general/curved_app_bar.dart';
import 'package:flutter/material.dart';

import '../../../model/user.dart';

class ProfileScreen extends StatelessWidget {
  final User user;

  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CurvedAppBar(title: 'Profile'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('ID : ${user.id}'),
            Text('Name : ${user.name}'),
            Text('Username : ${user.username}'),
            Text('Phone : ${user.phoneNumber}'),
          ],
        ),
      ),
    );
  }
}
