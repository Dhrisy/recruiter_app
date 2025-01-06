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