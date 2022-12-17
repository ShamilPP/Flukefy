import 'package:flukefy/utils/colors.dart';
import 'package:flukefy/view/screens/login/sign_up_screen.dart';
import 'package:flukefy/view/screens/login/widgets/login_text_field.dart';
import 'package:flukefy/view/screens/login/widgets/more_platforms.dart';
import 'package:flukefy/view/widgets/general/curved_app_bar.dart';
import 'package:flukefy/view_model/authentication_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../splash/splash_screen.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: const CurvedAppBar(
        title: 'Login',
      ),
      body: CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                welcomeSection(),
                LoginSection(),
                const MorePlatforms(),
                const SignUpText(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget welcomeSection() {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Welcome to Flukefy',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, fontFamily: 'roboto'),
          ),
          SizedBox(height: 10),
          Text(
            'Please sign in to continue',
            style: TextStyle(fontSize: 15, fontFamily: 'roboto'),
          ),
        ],
      ),
    );
  }
}

class LoginSection extends StatelessWidget {
  LoginSection({Key? key}) : super(key: key);

  final RoundedLoadingButtonController buttonController = RoundedLoadingButtonController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Login TextField
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(color: primaryColor.withOpacity(.4), blurRadius: 20, offset: const Offset(0, 10))],
            ),
            child: Column(
              children: <Widget>[
                // TextField
                LoginTextField(
                  hint: 'Username or Phone number',
                  controller: usernameController,
                ),
                LoginTextField(
                  hint: 'Password',
                  controller: passwordController,
                  isPassword: true,
                  keyboardType: TextInputType.visiblePassword,
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // Login button
          RoundedLoadingButton(
            width: 130,
            height: 45,
            color: primaryColor,
            successColor: Colors.green,
            controller: buttonController,
            onPressed: () async {
              AuthenticationProvider provider = Provider.of<AuthenticationProvider>(context, listen: false);
              bool status = await provider.login(usernameController.text, passwordController.text);
              if (status) {
                buttonController.success();
                await Future.delayed(const Duration(milliseconds: 500));
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SplashScreen()));
              } else {
                buttonController.error();
                await Future.delayed(const Duration(seconds: 2));
                buttonController.reset();
              }
            },
            child: const Text(
              'Sign in',
              style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class SignUpText extends StatelessWidget {
  const SignUpText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account ? ", style: TextStyle(fontSize: 14)),
        InkWell(
          splashColor: Colors.blue,
          child: const Text(
            'Sign up here',
            style: TextStyle(fontSize: 14, color: Colors.blue),
          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const SignUpScreen()));
          },
        ),
      ],
    );
  }
}
