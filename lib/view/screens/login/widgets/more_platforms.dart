import 'package:flukefy/utils/colors.dart';
import 'package:flukefy/view_model/authentication_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../model/enums/Authentication_type.dart';

class MorePlatforms extends StatelessWidget {
  const MorePlatforms({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // (or login with) divider
        divider(),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            LoginPlatform(
              type: AuthenticationType.guest,
              image: 'assets/images/platforms/guest.png',
            ),
            LoginPlatform(
              type: AuthenticationType.google,
              image: 'assets/images/platforms/google.png',
            ),
            LoginPlatform(
              type: AuthenticationType.facebook,
              image: 'assets/images/platforms/facebook.png',
            ),
          ],
        )
      ],
    );
  }

  // (or login with) divider
  Widget divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Row(
        children: [
          Expanded(child: Divider(thickness: 1.5, color: Colors.grey[700])),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text('Or login with'),
          ),
          Expanded(child: Divider(thickness: 1.5, color: Colors.grey[700])),
        ],
      ),
    );
  }
}

class LoginPlatform extends StatelessWidget {
  final AuthenticationType type;
  final String image;

  const LoginPlatform({Key? key, required this.type, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String tooltip = "${type.name[0].toUpperCase()}${type.name.substring(1).toLowerCase()}";
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        splashColor: primaryColor,
        child: Tooltip(
          message: tooltip,
          child: Ink.image(
            height: 40,
            width: 40,
            image: AssetImage(image),
          ),
        ),
        onTap: () {
          Provider.of<AuthenticationProvider>(context, listen: false).signInWithPlatforms(context, type);
        },
      ),
    );
  }
}
