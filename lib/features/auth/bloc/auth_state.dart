import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable{
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState{}

class AuthExists extends AuthState{}

class AuthLoading extends AuthState{}

class GetOtpInitial extends AuthState{}

class GetOtpSuccess extends AuthState{}

class GetOtpFailure extends AuthState{
  final String error;

  GetOtpFailure({required this.error});
   @override
  List<Object?> get props => [error];
}

class AuthSuccess extends AuthState{}

// email verify
class EmailVerifyNeeded extends AuthState{}
class EmailOtpSuccess extends AuthState{}
class EmailOtpFailure extends AuthState{
  final String error;
  EmailOtpFailure({required this.error});
   @override
  List<Object?> get props => [error];

}


class RegisterAuthSuccess extends AuthState{}

class RegisterOTPSuccess extends AuthState{

}


class RegisterOTPFailure extends AuthState{
  final String error;
  RegisterOTPFailure({required this.error});
   @override
  List<Object?> get props => [error];

}
class AuthFailure extends AuthState{
  final String error;

  AuthFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class OtpVerified extends AuthState{}
class OtpVerifiedFailed extends AuthState{
   final String error;

  OtpVerifiedFailed(this.error);

  @override
  List<Object?> get props => [error];
}

class OtpVerificationSuccess extends AuthState{}

class OtpVerificationFailure extends AuthState{}



// forgot password
class ForgotpasswordLoading extends AuthState{}
class ForgotPasswordSuccess extends AuthState{}
class ForgotPasswordFailure extends AuthState{
  final String error;

  ForgotPasswordFailure({required this.error});

   @override
  List<Object?> get props => [error];
}