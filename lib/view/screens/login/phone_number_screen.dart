import 'package:flukefy/utils/colors.dart';
import 'package:flukefy/view/screens/splash/splash_screen.dart';
import 'package:flukefy/view/widgets/buttons/black_button.dart';
import 'package:flukefy/view/widgets/general/curved_appbar.dart';
import 'package:flukefy/view_model/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../model/user.dart';

class PhoneNumberScreen extends StatelessWidget {
  final User user;

  PhoneNumberScreen({Key? key, required this.user}) : super(key: key);

  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CurvedAppBar(title: 'Login', backButton: false),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  const Text('Verify your phone number', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 30),
                  TextField(
                    style: TextStyle(color: primaryColor, fontSize: 16),
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Phone number',
                      prefixText: '+91 ',
                      prefixStyle: TextStyle(color: primaryColor, fontSize: 16),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: BlackButton(
                title: 'Verify',
                onPressed: () async {
                  int? number = int.tryParse(phoneController.text);
                  if (number != null && phoneController.text.length == 10) {
                    //show loading dialog
                    showDialog(context: context, builder: (ctx) => const Center(child: CircularProgressIndicator()));
                    user.phone = number;
                    bool isSuccess = await Provider.of<AuthProvider>(context, listen: false).addPhoneNumberToGoogle(context, user);
                    //Dismiss loading dialog
                    Navigator.pop(context);
                    if (isSuccess) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SplashScreen()));
                  } else {
                    Fluttertoast.showToast(msg: 'Error', backgroundColor: Colors.red);
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
