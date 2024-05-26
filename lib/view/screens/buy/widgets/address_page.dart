import 'package:flukefy/model/address.dart';
import 'package:flukefy/utils/colors.dart';
import 'package:flukefy/view/widgets/buttons/black_button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../../model/result.dart';
import '../../../../view_model/buy_provider.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({Key? key}) : super(key: key);

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController homeAddressController = TextEditingController();
  final TextEditingController roadAddressController = TextEditingController();

  @override
  void initState() {
    var provider = Provider.of<BuyProvider>(context, listen: false);
    provider.init(context);
    var address = provider.address;
    if (address != null) {
      if (address.name != null) nameController.text = address.name!;
      if (address.phone != null) phoneController.text = address.phone.toString();
      if (address.pinCode != null) pinCodeController.text = address.pinCode.toString();
      if (address.state != null) stateController.text = address.state!;
      if (address.city != null) cityController.text = address.city!;
      if (address.homeAddress != null) homeAddressController.text = address.homeAddress!;
      if (address.roadAddress != null) roadAddressController.text = address.roadAddress!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _addressField(
                      controller: nameController,
                      labelText: 'Full name',
                      hintText: 'Enter your full name',
                    ),
                    const SizedBox(height: 15),
                    _addressField(
                      controller: phoneController,
                      labelText: 'Phone number',
                      hintText: 'Enter your phone number',
                      prefixText: '+91',
                      isNumberKeyboard: true,
                    ),
                    const SizedBox(height: 15),
                    // Pin code
                    Row(
                      children: [
                        Expanded(
                          child: _addressField(
                            controller: pinCodeController,
                            labelText: 'Pin code',
                            hintText: 'Enter your pin code',
                            isNumberKeyboard: true,
                          ),
                        ),
                        const SizedBox(width: 15),
                        _locationButton(),
                      ],
                    ),
                    const SizedBox(height: 15),

                    // State and City
                    Row(
                      children: [
                        Expanded(
                          child: _addressField(controller: stateController, labelText: 'State', hintText: 'Enter your state'),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _addressField(controller: cityController, labelText: 'City', hintText: 'Enter your city'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),
                    _addressField(
                      controller: homeAddressController,
                      labelText: 'House no, Building name',
                      hintText: 'Enter your house no or building name',
                    ),
                    const SizedBox(height: 15),
                    _addressField(
                      controller: roadAddressController,
                      labelText: 'Road name, Area, Colony',
                      hintText: 'Enter your road name, area, or colony',
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: BlackButton(
                title: 'Next',
                onPressed: () async {
                  var isValid = _isAddressValid();
                  if (isValid.status == Status.success) {
                    // If entered all Information
                    // Show dialog (For animation)
                    showDialog(
                      context: context,
                      builder: (_) => const Center(child: CircularProgressIndicator()),
                    );
                    // Wait 1 second
                    await Future.delayed(const Duration(seconds: 1));
                    // Close dialog
                    Navigator.pop(context);
                    Provider.of<BuyProvider>(context, listen: false).setPage(2);
                  } else {
                    Fluttertoast.showToast(msg: isValid.message!);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _addressField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    String? prefixText,
    bool isNumberKeyboard = false,
  }) {
    return TextField(
      style: const TextStyle(color: Colors.black, fontSize: 16),
      controller: controller,
      keyboardType: isNumberKeyboard ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixText: prefixText,
        prefixStyle: const TextStyle(color: Colors.black, fontSize: 16),
        filled: true,
        fillColor: AppColors.secondaryColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(color: AppColors.dividerColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(color: AppColors.dividerColor, width: 1),
        ),
      ),
    );
  }

  Widget _locationButton() {
    return Expanded(
      child: SizedBox(
        height: 50,
        child: ElevatedButton.icon(
          onPressed: () => Fluttertoast.showToast(msg: 'Currently unavailable'),
          label: const Text('Use my location'),
          icon: const Icon(Icons.my_location),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
              side: const BorderSide(color: Colors.black, width: 1),
            ),
          ),
        ),
      ),
    );
  }

  Result<Address> _isAddressValid() {
    if (nameController.text.isEmpty) {
      return Result.error('Please enter your full name');
    } else if (phoneController.text.isEmpty) {
      return Result.error('Please enter your phone number');
    } else if (stateController.text.isEmpty) {
      return Result.error('Please enter your state');
    } else if (cityController.text.isEmpty) {
      return Result.error('Please enter your city');
    } else if (homeAddressController.text.isEmpty) {
      return Result.error('Please enter your house number or building name');
    } else if (roadAddressController.text.isEmpty) {
      return Result.error('Please enter your road name, area, or colony');
    } else if (phoneController.text.length != 10 || int.tryParse(phoneController.text) == null) {
      return Result.error('Please enter a valid 10-digit phone number (without +91)');
    } else if (pinCodeController.text.length != 6 || int.tryParse(pinCodeController.text) == null) {
      return Result.error('Please enter a valid 6-digit pin code');
    }
    return Result.success(Address(
      name: nameController.text,
      phone: int.parse(phoneController.text),
      pinCode: int.parse(pinCodeController.text),
      state: stateController.text,
      city: cityController.text,
      homeAddress: homeAddressController.text,
      roadAddress: roadAddressController.text,
    ));
  }
}
