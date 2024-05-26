import 'package:flukefy/view/screens/splash/splash_screen.dart';
import 'package:flukefy/view/widgets/dialog/custom_dialog.dart';
import 'package:flukefy/view_model/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/colors.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 45,
      child: TextButton(
        child: Text(
          'Logout',
          style: TextStyle(fontSize: 20, color: AppColors.primaryColor),
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (_) => CustomDialog(
                    title: 'Logout',
                    content: 'Are you sure ?',
                    buttonText: 'Logout',
                    onButtonPressed: () async {
                      // remove user from shared preferences
                      await Provider.of<AuthProvider>(context, listen: false).logout().then((value) {
                        // then, go to login screen
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const SplashScreen()), (Route<dynamic> route) => false);
                      });
                    },
                  )
              // builder: (_) => AlertDialog(
              //   title: const Text('Logout'),
              //   content: const Text('Are you sure ?'),
              //   actions: [
              //     BlackButton(
              //       title: 'Logout',
              //       onPressed: () async {
              //         // remove user from shared preferences
              //         await Provider.of<AuthProvider>(context, listen: false).logout().then((value) {
              //           // then, go to login screen
              //           Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const SplashScreen()), (Route<dynamic> route) => false);
              //         });
              //       },
              //     ),
              //   ],
              // ),
              );
        },
      ),
    );
  }
}
