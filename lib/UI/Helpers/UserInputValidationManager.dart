import 'package:flutter/material.dart';
import 'package:validators/validators.dart';
import 'package:validators/sanitizers.dart';

class UserInputValidationManager {
  UserInputValidationManager();

  bool isNameValid(String name) {
    RegExp _namePattern =
        new RegExp(r'^[a-záéíóúàèìòùãõâîôûêç A-ZÁÉÍÓÚÀÈÌÒÙNÃÕÂÔÊÎÛÇ]+$');
    return _namePattern.hasMatch(name);
  }

  bool isEmailValid(String email) {
    return isEmail(email);
  }

  bool isNumeric(String str) {
  }

  void clear(List<TextEditingController> controllers, FocusNode node,
      BuildContext context) {
    for (TextEditingController c in controllers) {
      c.clear();
    }
    FocusScope.of(context).requestFocus(node);
  }

  String sanitizePhoneNumbers(String str) {
    String newString = blacklist(str, " ,.-/()");
    String sanitizedString = newString.contains("-") ? newString.replaceAll(RegExp(r'-'), "") : newString;
    sanitizedString =
    sanitizedString.indexOf("00") == 0 || sanitizedString.indexOf("0") == 0
            ? sanitizedString.replaceFirst(RegExp('[' + "00" + ']+'), "+")
            : sanitizedString.contains("+") ? sanitizedString : "+351$sanitizedString";
    return sanitizedString;
  }

  String sanitizeEmail(String email) {
    if (isEmail(email)) {
      return normalizeEmail(email);
    }
    return email;
  }
}
