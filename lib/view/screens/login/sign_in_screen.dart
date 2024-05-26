import 'package:flukefy/model/result.dart';
import 'package:flukefy/utils/colors.dart';
import 'package:flukefy/view/animations/fade_animation.dart';
import 'package:flukefy/view/screens/login/sign_up_screen.dart';
import 'package:flukefy/view/screens/login/widgets/login_text_field.dart';
import 'package:flukefy/view/screens/login/widgets/more_platforms.dart';
import 'package:flukefy/view/widgets/general/curved_appbar.dart';
import 'package:flukefy/view_model/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../view_model/utils/helper.dart';
import '../splash/splash_screen.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
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
    return const Padding(
      padding: EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeAnimation(
            delay: 100,
            child: Text(
              'Welcome to Flukefy',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, fontFamily: 'roboto'),
            ),
          ),
          SizedBox(height: 10),
          FadeAnimation(
            delay: 200,
            child: Text(
              'Please sign in to continue',
              style: TextStyle(fontSize: 15, fontFamily: 'roboto'),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginSection extends StatelessWidget {
  LoginSection({Key? key}) : super(key: key);

  final RoundedLoadingButtonController buttonController = RoundedLoadingButtonController();
  final TextEditingController emailController = TextEditingController();
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
              boxShadow: [BoxShadow(color: AppColors.primaryColor.withOpacity(.4), blurRadius: 20, offset: const Offset(0, 10))],
            ),
            child: Column(
              children: <Widget>[
                // TextField
                FadeAnimation(
                  delay: 300,
                  child: LoginTextField(
                    hint: 'Email',
                    controller: emailController,
                  ),
                ),
                FadeAnimation(
                  delay: 400,
                  child: LoginTextField(
                    hint: 'Password',
                    controller: passwordController,
                    isPassword: true,
                    keyboardType: TextInputType.visiblePassword,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // Login button
          FadeAnimation(
            delay: 500,
            child: RoundedLoadingButton(
              width: 130,
              height: 45,
              color: AppColors.primaryColor,
              successColor: Colors.green,
              controller: buttonController,
              onPressed: () async {
                AuthProvider provider = Provider.of<AuthProvider>(context, listen: false);
                var result = await provider.login(emailController.text, passwordController.text);
                if (result.status == Status.success) {
                  buttonController.success();
                  await Future.delayed(const Duration(milliseconds: 500));
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SplashScreen()));
                } else {
                  Helper.showToast(result.message!, Colors.red);
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
    return FadeAnimation(
      delay: 900,
      child: Row(
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
      ),
    );
  }
}
