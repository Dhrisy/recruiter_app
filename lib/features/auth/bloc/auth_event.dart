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


class LoginEvent extends AuthEvent{
  final String email;
  final String password;

  LoginEvent({
    required this.email,
    required this.password
  });

  @override
  List<Object?> get props => [email, password];
}