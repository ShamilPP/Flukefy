import 'package:flukefy/model/user.dart';
import 'package:flukefy/utils/colors.dart';
import 'package:flukefy/view/animations/fade_animation.dart';
import 'package:flukefy/view/screens/login/widgets/login_text_field.dart';
import 'package:flukefy/view/screens/login/widgets/more_platforms.dart';
import 'package:flukefy/view/widgets/general/curved_appbar.dart';
import 'package:flukefy/view_model/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../model/result.dart';
import '../../../view_model/utils/helper.dart';
import '../splash/splash_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const CurvedAppBar(
        title: 'Register',
      ),
      body: CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  welcomeSection(),
                  LoginSection(),
                  const MorePlatforms(),
                ],
              ),
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
              'Create new account',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, fontFamily: 'roboto'),
            ),
          ),
          SizedBox(height: 10),
          FadeAnimation(
            delay: 200,
            child: Text(
              'Ready to start using Flukefy app',
              style: TextStyle(fontSize: 15, fontFamily: 'roboto'),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class LoginSection extends StatefulWidget {
  LoginSection({Key? key}) : super(key: key);

  @override
  State<LoginSection> createState() => _LoginSectionState();
}

class _LoginSectionState extends State<LoginSection> {
  final RoundedLoadingButtonController buttonController = RoundedLoadingButtonController();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isNameValid = true;
  bool isEmailValid = true;
  bool isPhoneValid = true;
  bool isPasswordValid = true;
  bool isConfirmPasswordValid = true;

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
                    hint: 'Full name',
                    controller: nameController,
                    keyboardType: TextInputType.name,
                    errorText: !isNameValid ? 'Please enter a valid name' : null,
                    onChanged: (text) {
                      if (!isNameValid) {
                        setState(() {
                          isNameValid = true;
                        });
                      }
                    },
                  ),
                ),
                FadeAnimation(
                  delay: 400,
                  child: LoginTextField(
                    hint: 'Phone number',
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    errorText: !isPhoneValid ? 'Please enter a valid phone number' : null,
                    onChanged: (text) {
                      if (!isPhoneValid) {
                        setState(() {
                          isPhoneValid = true;
                        });
                      }
                    },
                  ),
                ),
                FadeAnimation(
                  delay: 500,
                  child: LoginTextField(
                    hint: 'Email',
                    controller: emailController,
                    errorText: !isEmailValid ? 'Please enter a valid email address' : null,
                    onChanged: (text) {
                      if (!isEmailValid) {
                        setState(() {
                          isEmailValid = true;
                        });
                      }
                    },
                  ),
                ),
                FadeAnimation(
                  delay: 600,
                  child: LoginTextField(
                    hint: 'Password',
                    controller: passwordController,
                    isPassword: true,
                    keyboardType: TextInputType.visiblePassword,
                    errorText: !isPasswordValid ? 'Please enter a valid password' : null,
                    onChanged: (text) {
                      if (!isPasswordValid) {
                        setState(() {
                          isPasswordValid = true;
                        });
                      }
                    },
                  ),
                ),
                FadeAnimation(
                  delay: 700,
                  child: LoginTextField(
                    hint: 'Confirm password',
                    controller: confirmPasswordController,
                    isPassword: true,
                    keyboardType: TextInputType.visiblePassword,
                    errorText: !isConfirmPasswordValid ? 'Passwords do not match' : null,
                    onChanged: (text) {
                      if (!isConfirmPasswordValid) {
                        setState(() {
                          isConfirmPasswordValid = true;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // Login button
          FadeAnimation(
            delay: 800,
            child: RoundedLoadingButton(
              width: 130,
              height: 45,
              color: AppColors.primaryColor,
              successColor: Colors.green,
              controller: buttonController,
              onPressed: signUp,
              child: const Text(
                'Sign up',
                style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void signUp() async {
    setState(() {
      isNameValid = nameController.text.isNotEmpty;
      isPhoneValid = ((int.tryParse(phoneController.text) != null) && phoneController.text.length == 10);
      isEmailValid = emailController.text.isValidEmail();
      isPasswordValid = passwordController.text.isNotEmpty;
      isConfirmPasswordValid = (passwordController.text == confirmPasswordController.text) && confirmPasswordController.text.isNotEmpty;
    });
    if (isNameValid && isPhoneValid && isEmailValid && isPasswordValid && isConfirmPasswordValid) {
      AuthProvider provider = Provider.of<AuthProvider>(context, listen: false);
      User user = User(
        name: nameController.text,
        email: emailController.text,
        phone: int.parse(phoneController.text),
      );

      var result = await provider.createAccount(user, passwordController.text);
      if (result.status == ResultStatus.success) {
        buttonController.success();
        await Future.delayed(const Duration(milliseconds: 500));
        Navigator.push(context, MaterialPageRoute(builder: (_) => const SplashScreen()));
      } else {
        Helper.showToast(result.message!, Colors.red);
        buttonController.error();
        await Future.delayed(const Duration(seconds: 2));
        buttonController.reset();
      }
    } else {
      buttonController.error();
      await Future.delayed(const Duration(seconds: 1));
      buttonController.reset();
    }
  }
}
