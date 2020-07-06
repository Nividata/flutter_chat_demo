extension ValidationExtension on String {
  String validNumber() {
    if (this.isEmpty) {
      return "*required";
    } else if (this.length < 10) {
      return "Invalid phone number";
    } else {
      return null;
    }
  }

  String validOtp() {
    if (this.isEmpty) {
      return "*required";
    } else if (this.length < 6) {
      return "Invalid otp";
    } else {
      return null;
    }
  }

  String validEmail() {
    const _emailRegExpString = r'[a-zA-Z0-9\+\.\_\%\-\+]{1,256}\@[a-zA-Z0-9]'
        r'[a-zA-Z0-9\-]{0,64}(\.[a-zA-Z0-9][a-zA-Z0-9\-]{0,25})+';

    if (this.isEmpty) {
      return "*required";
    } else if (!RegExp(_emailRegExpString, caseSensitive: false)
        .hasMatch(this)) {
      return "Invalid email address";
    } else {
      return null;
    }
  }

  String validPassword() {
    if (this.isEmpty) {
      return "*required";
    } else if (this.length < 2) {
      return "Invalid password";
    } else {
      return null;
    }
  }
}
