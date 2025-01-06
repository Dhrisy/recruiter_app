abstract class AuthEvent{

@override
  List<Object?> get props => [];
}

class RegisterEvent extends AuthEvent{
   final String companyName;
    final String email;
    final String contactNumber;
    final String password;
    final String role;
    final bool whatsappUpdations;

    RegisterEvent({
      required this.companyName,
      required this.contactNumber,
      required this.email,
      required this.password,
      required this.role,
      required this.whatsappUpdations
    });
@override
  List<Object?> get props => [
    companyName, email, contactNumber, password, role, whatsappUpdations
  ];

}


class EmailLoginEvent extends AuthEvent{
  final String email;
  final String password;

  EmailLoginEvent({
    required this.email,
    required this.password
  });

  @override
  List<Object?> get props => [email, password];
}

class GetOtpEVent extends AuthEvent{
  final String phone;

  GetOtpEVent({required this.phone});
  @override
  List<Object?> get props => [phone];

}

class PhoneLoginEvent extends AuthEvent{
  final String phone;
  PhoneLoginEvent({required this.phone});
   @override
  List<Object?> get props => [phone];
}

class MobileOtpVerifyEvent extends AuthEvent{
  final String phone;
  final String otp;

  MobileOtpVerifyEvent({ required this.phone, required this.otp});
   @override
  List<Object?> get props => [phone];
}


class ClearEvent extends AuthEvent{}