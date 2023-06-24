/// Response from phone authentication
sealed class PhoneAuthResponse {
  const PhoneAuthResponse();
}

class PhoneAuthResponseCodeSent extends PhoneAuthResponse {
  final String verificationId;

  const PhoneAuthResponseCodeSent(this.verificationId);
}

class PhoneAuthResponseCodeAutoRetrievalTimeout extends PhoneAuthResponse {
  final String verificationId;

  const PhoneAuthResponseCodeAutoRetrievalTimeout(this.verificationId);
}

class PhoneAuthResponseVerificationCompleted extends PhoneAuthResponse {
  const PhoneAuthResponseVerificationCompleted();
}

class PhoneAuthResponseVerificationFailed extends PhoneAuthResponse {
  final String message;

  const PhoneAuthResponseVerificationFailed(this.message);
}
