import 'package:flukefy/model/product.dart';
import 'package:flukefy/model/user.dart';
import 'package:flukefy/view/animations/size_animation.dart';
import 'package:flukefy/view/screens/buy/buy_screen.dart';
import 'package:flukefy/view/screens/home/home_screen.dart';
import 'package:flukefy/view/screens/profile/profile_screen.dart';
import 'package:flukefy/view_model/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class TestSplashScreen extends StatefulWidget {
  const TestSplashScreen({Key? key}) : super(key: key);

  @override
  State<TestSplashScreen> createState() => _TestSplashScreenState();
}

class _TestSplashScreenState extends State<TestSplashScreen> {
  @override
  void initState() {
    testInit(context);
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
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitFadingCube(color: Colors.white, size: 25),
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

  void testInit(BuildContext context) async {
    await Future.delayed(Duration(seconds: 1));
    Provider.of<UserProvider>(context, listen: false).setUser(User(name: 'Shamil', email: 'Test@gmail.com', phone: 1234567890));
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
  }
}
