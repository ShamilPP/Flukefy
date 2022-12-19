import 'package:flukefy/services/firebase_service.dart';
import 'package:flukefy/view/animations/size_animation.dart';
import 'package:flukefy/view/screens/home/home_screen.dart';
import 'package:flukefy/view/screens/introduction/introduction_screen.dart';
import 'package:flukefy/view_model/authentication_provider.dart';
import 'package:flukefy/view_model/splash_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/user.dart';
import '../../../view_model/user_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    goToHomeScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizeAnimation(
              delay: 300,
              child: Center(
                child: Image.asset(
                  'assets/icon.png',
                  width: 200,
                  height: 200,
                ),
              ),
            ),
            SizeAnimation(
              delay: 800,
              child: Container(
                margin: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(
                      color: Colors.white,
                    ),
                    SizedBox(width: 30),
                    Text(
                      "Fetching account details....",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void goToHomeScreen() {
    Future.delayed(const Duration(seconds: 2)).then((value) async {
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      String? userId = await userProvider.getUserIdFromLocal();
      if (userId != null) {
        User? user = await FirebaseService.getUserWithDocId(userId);
        if (user != null) {
          userProvider.setUser(user);
        } else {
          await Provider.of<AuthenticationProvider>(context, listen: false).logout();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const IntroductionScreen()));
        }
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const IntroductionScreen()));
      }
    });

    Provider.of<SplashProvider>(context, listen: false).init(context);
  }
}
