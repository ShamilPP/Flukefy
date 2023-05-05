import 'package:flukefy/view/screens/buy/buy_screen.dart';
import 'package:flukefy/view/widgets/buttons/black_button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddressPage extends StatelessWidget {
  AddressPage({Key? key}) : super(key: key);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController homeAddressController = TextEditingController();
  final TextEditingController roadAddressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    AddressTextField(nameController: nameController, labelText: 'Full name'),
                    const SizedBox(height: 15),
                    AddressTextField(
                        nameController: phoneController, labelText: 'Phone number', prefixText: '+91', isNumberKeyboard: true),
                    const SizedBox(height: 15),
                    // Pin code
                    Row(
                      children: [
                        Expanded(
                            child: AddressTextField(
                                nameController: pinCodeController, labelText: 'Pin code', isNumberKeyboard: true)),
                        const SizedBox(width: 15),
                        locationButton()
                      ],
                    ),
                    const SizedBox(height: 15),

                    // State and City
                    Row(
                      children: [
                        Expanded(child: AddressTextField(nameController: stateController, labelText: 'State')),
                        const SizedBox(width: 15),
                        Expanded(child: AddressTextField(nameController: cityController, labelText: 'City')),
                      ],
                    ),

                    const SizedBox(height: 15),
                    AddressTextField(nameController: homeAddressController, labelText: 'House no, Building name'),
                    const SizedBox(height: 15),
                    AddressTextField(nameController: roadAddressController, labelText: 'Road name, Area, Colony'),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: BlackButton(
                title: 'Next',
                onPressed: () async {
                  if (nameController.text != '' &&
                      phoneController.text != '' &&
                      stateController.text != '' &&
                      cityController.text != '' &&
                      homeAddressController.text != '' &&
                      roadAddressController.text != '' &&
                      // Phone number checking
                      int.tryParse(phoneController.text) != null &&
                      phoneController.text.length == 10 &&
                      // Pin code checking
                      int.tryParse(pinCodeController.text) != null &&
                      pinCodeController.text.length == 6) {
                    // If entered all Information
                    // Show dialog (For animation)
                    showDialog(context: context, builder: (_) => const Center(child: CircularProgressIndicator()));
                    // Wait 1 second
                    await Future.delayed(const Duration(seconds: 1));
                    // Close dialog
                    Navigator.pop(context);
                    BuyScreen.pageNotifier.value = 2;
                  } else {
                    Fluttertoast.showToast(msg: 'Fill out all box');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget locationButton() {
    return Expanded(
      child: SizedBox(
        height: 50,
        child: ElevatedButton.icon(
          onPressed: () => Fluttertoast.showToast(msg: 'Currently unavailable'),
          label: const Text('Use my location'),
          icon: const Icon(Icons.my_location),
        ),
      ),
    );
  }
}

class AddressTextField extends StatelessWidget {
  final TextEditingController nameController;
  final String labelText;
  final String? prefixText;
  final bool isNumberKeyboard;

  const AddressTextField({
    Key? key,
    required this.nameController,
    required this.labelText,
    this.prefixText,
    this.isNumberKeyboard = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: Colors.black, fontSize: 16),
      controller: nameController,
      keyboardType: isNumberKeyboard ? TextInputType.number : null,
      decoration: InputDecoration(
        labelText: labelText,
        prefixText: prefixText,
        prefixStyle: const TextStyle(color: Colors.black, fontSize: 16),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(7)),
          borderSide: BorderSide(color: Colors.black, width: 1),
        ),
      ),
    );
  }
}
