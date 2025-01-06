import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:recruiter_app/features/auth/bloc/auth_event.dart';
import 'package:recruiter_app/features/auth/bloc/auth_state.dart';
import 'package:recruiter_app/features/auth/data/auth_repository.dart';
import 'package:recruiter_app/services/login_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final _storage = FlutterSecureStorage();
  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<RegisterEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final success = await authRepository.register(
            companyName: event.companyName,
            email: event.email,
            contactNumber: event.contactNumber,
            password: event.password,
            role: event.role,
            whatsappUpdations: event.whatsappUpdations);

        if (success == "success") {
          emit(AuthSuccess());
        } else if (success == "User already exists") {
          emit(AuthExists());
        } else {
          emit(AuthFailure("Something went wrong. Regiseration failed"));
        }
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<EmailLoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final success = await authRepository.emailLogin(
            email: event.email, password: event.password);

        if (success == "success") {
          await _storage.write(key: "user", value: "installed");

          emit(AuthSuccess());
        } else {
          emit(AuthFailure(success.toString()));
        }
      } catch (e) {
        print("Auth repository error  $e");
        emit(AuthFailure(e.toString()));
      }
    });

    on<GetOtpEVent>((event, emit) async {
      emit(GetOtpInitial());
      emit(AuthLoading());

      try {
        final response = await authRepository.getPhoneOtp(phone: event.phone);

        

        if (response != null && response == "success") {
          emit(GetOtpSuccess());
        } else {
          emit(GetOtpFailure(error: response.toString()));
        }
      } catch (e) {
        emit(GetOtpFailure(error: e.toString()));
      }
    });

    on<PhoneLoginEvent>((event, emit) async {
      emit(GetOtpInitial());
      try {
        final response = await authRepository.phoneLogin(phone: event.phone);
        if(response == "success"){
          emit(GetOtpSuccess());
        }else{
          emit(GetOtpFailure(error: response.toString()));
        }
      } catch (e) {
         emit(GetOtpFailure(error: e.toString()));
      }
    });

    on<MobileOtpVerifyEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final response = await authRepository.mobileOtpVerify(
            phone: event.phone, otp: event.otp);
        if (response == "success") {
          emit(OtpVerified());
        } else {
          emit(OtpVerifiedFailed(response.toString()));
        }
      } catch (e) {
        emit(OtpVerifiedFailed(e.toString()));
      }
    });

    on<ClearEvent>((event, emit) {
      emit(AuthInitial());
    });
  }
}
