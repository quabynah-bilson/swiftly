import 'constants.dart';

/// Format phone number with dial code
String formatPhoneNumberWithDialCode(String phoneNumber, String? dialCode) {
  dialCode = dialCode ?? kDefaultDialCode; // default dial code
  if (phoneNumber.startsWith(dialCode) || phoneNumber.startsWith('+')) {
    return phoneNumber;
  }

  // replace all special characters (except +) with empty string
  phoneNumber = phoneNumber.replaceAll(RegExp(r'[^+\d]'), '');

  // check if phone number starts with 0
  if (phoneNumber.startsWith('0')) phoneNumber = phoneNumber.substring(1);
  return '$dialCode$phoneNumber';
}
