extension EmailValidator on String {
  bool isValidEmail() {
    bool result1 = RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
    bool result2 = false;
    if (length > 10) {
      result2 = substring(length - 10) == '@gmail.com';
    }
    return result1 && result2;
  }
}
