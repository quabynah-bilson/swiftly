import 'package:shared_utils/shared_utils.dart' show TextX;

String hashCreditCardNumber(String? creditCardNumber) {
  if (creditCardNumber.isNullOrEmpty()) return '';
  return creditCardNumber!.replaceRange(0, 14, '**** **** **** ');
}
