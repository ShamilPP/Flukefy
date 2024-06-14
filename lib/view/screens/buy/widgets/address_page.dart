import 'package:flukefy/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../view_model/buy_provider.dart';

class AddressPage extends StatefulWidget {
  AddressPage({Key? key}) : super(key: key);

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController address1Controller = TextEditingController();
  final TextEditingController address2Controller = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();

  bool isNameValid = true;
  bool isPhoneValid = true;
  bool isAddress1Valid = true;
  bool isAddress2Valid = true;
  bool isStateValid = true;
  bool isCityValid = true;
  bool isPinCodeValid = true;

  @override
  void initState() {
    var address = Provider.of<BuyProvider>(context, listen: false).address;
    if (address != null) {
      nameController.text = address.name ?? '';
      phoneController.text = address.phone != null ? address.phone.toString() : '';
      address1Controller.text = address.address1 ?? '';
      address2Controller.text = address.address2 ?? '';
      stateController.text = address.state ?? '';
      cityController.text = address.city ?? '';
      pinCodeController.text = address.pinCode != null ? address.pinCode.toString() : '';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Shipping Address",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
            ),
            const SizedBox(height: 20),
            _buildTextField(
              label: "Full Name",
              controller: nameController,
              errorText: !isNameValid ? 'Please enter a valid name' : null,
              onChanged: (text) {
                if (!isNameValid) {
                  setState(() {
                    isNameValid = true;
                  });
                }
              },
            ),
            const SizedBox(height: 10),
            _buildTextField(
              label: "Phone number",
              controller: phoneController,
              errorText: !isPhoneValid ? 'Please enter a valid phone number' : null,
              onChanged: (text) {
                if (!isPhoneValid) {
                  setState(() {
                    isPhoneValid = true;
                  });
                }
              },
            ),
            const SizedBox(height: 10),
            _buildTextField(
              label: "Address Line 1",
              controller: address1Controller,
              errorText: !isAddress1Valid ? 'Please enter a valid address' : null,
              onChanged: (text) {
                if (!isAddress1Valid) {
                  setState(() {
                    isAddress1Valid = true;
                  });
                }
              },
            ),
            const SizedBox(height: 10),
            _buildTextField(
              label: "Address Line 2",
              controller: address2Controller,
              errorText: !isAddress2Valid ? 'Please enter a valid address' : null,
              onChanged: (text) {
                if (!isAddress2Valid) {
                  setState(() {
                    isAddress2Valid = true;
                  });
                }
              },
            ),
            const SizedBox(height: 10),
            _buildTextField(
              label: "State",
              controller: stateController,
              errorText: !isStateValid ? 'Please enter a valid state' : null,
              onChanged: (text) {
                if (!isStateValid) {
                  setState(() {
                    isStateValid = true;
                  });
                }
              },
            ),
            const SizedBox(height: 10),
            _buildTextField(
              label: "City",
              controller: cityController,
              errorText: !isCityValid ? 'Please enter a valid city' : null,
              onChanged: (text) {
                if (!isCityValid) {
                  setState(() {
                    isCityValid = true;
                  });
                }
              },
            ),
            const SizedBox(height: 10),
            _buildTextField(
              label: "Postal Code",
              controller: pinCodeController,
              errorText: !isPinCodeValid ? 'Please enter a valid postal code' : null,
              onChanged: (text) {
                if (!isPinCodeValid) {
                  setState(() {
                    isPinCodeValid = true;
                  });
                }
              },
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isNameValid = nameController.text.isNotEmpty;
                    isPhoneValid = ((int.tryParse(phoneController.text) != null) && phoneController.text.length == 10);
                    isAddress1Valid = address1Controller.text.isNotEmpty;
                    isAddress2Valid = address2Controller.text.isNotEmpty;
                    isStateValid = stateController.text.isNotEmpty;
                    isCityValid = cityController.text.isNotEmpty;
                    isPinCodeValid = ((int.tryParse(pinCodeController.text) != null) && pinCodeController.text.length == 6);
                    ;
                  });
                  if (isNameValid && isPhoneValid && isAddress1Valid && isAddress2Valid && isStateValid && isCityValid && isPinCodeValid) {
                    Provider.of<BuyProvider>(context, listen: false).setPage(2);
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: AppColors.textSecondaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                child: const Text("Continue to Payment"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, required TextEditingController controller, required String? errorText, required void Function(String) onChanged}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        labelStyle: TextStyle(color: Colors.grey.shade800),
        errorText: errorText,
      ),
      onChanged: onChanged,
    );
  }
}
