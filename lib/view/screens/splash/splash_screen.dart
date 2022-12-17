import 'package:flukefy/services/local_service.dart';
import 'package:flukefy/view/animations/size_animation.dart';
import 'package:flukefy/view/screens/home/home_screen.dart';
import 'package:flukefy/view/screens/introduction/introduction_screen.dart';
import 'package:flukefy/view_model/splash_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      bool userIsLoggedIn = await Provider.of<SplashProvider>(context, listen: false).userIsLoggedIn();
      if (userIsLoggedIn) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const IntroductionScreen()));
      }
    });

    Provider.of<SplashProvider>(context, listen: false).init(context);
  }
}
