import 'package:flukefy/utils/colors.dart';
import 'package:flukefy/view/animations/slide_animation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../view_model/auth_provider.dart';

class MorePlatforms extends StatelessWidget {
  const MorePlatforms({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // (or login with) divider
        divider(),
        const SizedBox(height: 20),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SlideAnimation(
              delay: 600,
              position: SlidePosition.left,
              child: LoginPlatform(
                type: AuthType.guest,
                image: 'assets/images/platforms/guest.png',
              ),
            ),
            SlideAnimation(
              delay: 700,
              position: SlidePosition.left,
              child: LoginPlatform(
                type: AuthType.google,
                image: 'assets/images/platforms/google.png',
              ),
            ),
            SlideAnimation(
              delay: 800,
              position: SlidePosition.left,
              child: LoginPlatform(
                type: AuthType.facebook,
                image: 'assets/images/platforms/facebook.png',
              ),
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
  final AuthType type;
  final String image;

  const LoginPlatform({Key? key, required this.type, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String tooltip = "${type.name[0].toUpperCase()}${type.name.substring(1).toLowerCase()}";
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Stack(
        children: [
          Image.asset(image, height: 40, width: 40),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(30),
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                splashColor: primaryColor,
                child: Tooltip(message: tooltip),
                onTap: () {
                  if (type == AuthType.google) {
                    Provider.of<AuthProvider>(context, listen: false).signInWithGoogle(context);
                  } else if (type == AuthType.facebook) {
                    Provider.of<AuthProvider>(context, listen: false).signInWithFacebook(context);
                  } else if (type == AuthType.guest) {
                    Provider.of<AuthProvider>(context, listen: false).signInWitGuest(context);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
