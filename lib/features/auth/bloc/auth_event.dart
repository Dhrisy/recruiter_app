abstract class AuthEvent {
  @override
  List<Object?> get props => [];
}

class RegisterEvent extends AuthEvent {
  final String companyName;
  final String email;
  final String contactNumber;
  final String password;
  final String role;
  final bool whatsappUpdations;
  final int planId;
  final String transactionId;

  RegisterEvent(
      {required this.companyName,
      required this.contactNumber,
      required this.email,
      required this.password,
      required this.role,
      required this.whatsappUpdations,
      required this.planId,
      required this.transactionId});
  @override
  List<Object?> get props =>
      [companyName, email, contactNumber, password, role, whatsappUpdations];
}

class EmailLoginEvent extends AuthEvent {
  final String email;
  final String password;

  EmailLoginEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class GetOtpEVent extends AuthEvent {
  final String phone;

  GetOtpEVent({required this.phone});
  @override
  List<Object?> get props => [phone];
}

class PhoneLoginEvent extends AuthEvent {
  final String phone;
  PhoneLoginEvent({required this.phone});
  @override
  List<Object?> get props => [phone];
}

class MobileOtpVerifyEvent extends AuthEvent {
  final String phone;
  final String otp;

  MobileOtpVerifyEvent({required this.phone, required this.otp});
  @override
  List<Object?> get props => [phone];
}

class ClearEvent extends AuthEvent {}

// email verification
class EmailSentOtpEvent extends AuthEvent{

  final String email;

  EmailSentOtpEvent({required this.email});
   @override
  List<Object?> get props => [email];

}

class EmailOtpVerifyEVent extends AuthEvent{
  final String otp;
  final String email;

  EmailOtpVerifyEVent({required this.otp, required this.email});
   @override
  List<Object?> get props => [otp, email];
}

class OTPEvent extends AuthEvent {
  final String otp;
  OTPEvent({required this.otp});
  @override
  List<Object?> get props => [otp];
}


// forgot pw event
class ForgotPasswordEvent extends AuthEvent {
  final String phone;

  ForgotPasswordEvent({required this.phone});

  @override
  List<Object?> get props => [phone];
}
