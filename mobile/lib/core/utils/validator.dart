import 'package:shared_utils/shared_utils.dart' show TextX;

class Validators {
  static String? validate(String? input) {
    if (input.isNullOrEmpty()) return 'Required';
    return null;
  }

  static String? validateAuthCode(String? input) {
    input = input?.replaceAll(' ', '');
    if (input.isNullOrEmpty()) return 'Required';
    var regex = RegExp(r'^\d{6}$');
    return regex.hasMatch(input!.trim()) ? null : 'Invalid verification code';
  }

  static String? validatePhone(String? input) {
    input = input?.replaceAll(' ', '');
    if (input.isNullOrEmpty()) return 'Required';
    var regex =
        RegExp(r'^[+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$');
    return regex.hasMatch(input!.trim()) ? null : 'Invalid phone number';
  }
}
