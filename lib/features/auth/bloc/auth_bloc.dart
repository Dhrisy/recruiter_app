import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:recruiter_app/core/utils/custom_functions.dart';
import 'package:recruiter_app/features/auth/bloc/auth_event.dart';
import 'package:recruiter_app/features/auth/bloc/auth_state.dart';
import 'package:recruiter_app/features/auth/data/auth_repository.dart';
import 'package:recruiter_app/services/auth_services/login_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final _storage = FlutterSecureStorage();
  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<RegisterEvent>((event, emit) async {
      emit(AuthLoading());

         final connectivityResult = await CustomFunctions.checkNetworkConnection();
    if(connectivityResult != null){
     emit(AuthFailure(connectivityResult.toString()));
    }


      try {
        final success = await authRepository.register(
            companyName: event.companyName,
            email: event.email,
            contactNumber: event.contactNumber,
            password: event.password,
            role: event.role,
            whatsappUpdations: event.whatsappUpdations);

        if (success == "success") {
          emit(RegisterAuthSuccess());
        } else if (success == "User already exists") {
          emit(AuthExists());
        } else {
          emit(AuthFailure(success.toString()));
        }
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<EmailLoginEvent>((event, emit) async {
      emit(AuthLoading());

       final connectivityResult = await CustomFunctions.checkNetworkConnection();
    if(connectivityResult != null){
     emit(AuthFailure(connectivityResult.toString()));
    }else{

      try {
        final success = await authRepository.emailLogin(
          context: event.context,
            email: event.email, password: event.password);

        if (success == "success") {
          await _storage.write(key: "user", value: "installed");

          emit(AuthSuccess());
        } else {
          if (success == "Email not verified for login") {
            emit(EmailVerifyNeeded());
          } else {
            emit(AuthFailure(success.toString()));
          }
        }
      } catch (e) {
        print("Auth repository error  $e");
        emit(AuthFailure(e.toString()));
      }
    }


    });

    on<GetOtpEVent>((event, emit) async {
      emit(GetOtpInitial());
      emit(AuthLoading());

      try {
        final response = await authRepository.resendOTP(phone: event.phone);

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
        if (response == "success") {
          emit(GetOtpSuccess());
        } else {
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

    on<OTPEvent>((event, emit) {
      emit(AuthLoading());
    });

// get email otp
    on<EmailSentOtpEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final result = await AuthRepository().emailSentOtp(email: event.email);
        if (result == "success") {
          emit(GetOtpSuccess());
        } else {
          emit(GetOtpFailure(error: result.toString()));
        }
      } catch (e) {
        emit(GetOtpFailure(error: e.toString()));
      }
    });

    // email otp verify
    on<EmailOtpVerifyEVent>((event, emit) async {
      emit(AuthLoading());

      try {
        final result = await AuthRepository()
            .emailOtpVerify(otp: event.otp, email: event.email);

        if (result == "success") {
          emit(OtpVerified());
        } else {
          emit(OtpVerifiedFailed(result.toString()));
        }
      } catch (e) {
        print(e);

        emit(OtpVerifiedFailed(e.toString()));
      }
    });

// forgot password
    on<ForgotPasswordEvent>((event, emit) async {
      emit(ForgotpasswordLoading());

      try {
        final result = await AuthRepository().forgotPw(phone: event.phone);
        if (result == "OTP sent to mobile") {
          emit(ForgotPasswordSuccess());
        } else {
          emit(ForgotPasswordFailure(
              error: "Failed to send OTP. Please try again later"));
        }
      } catch (e) {
        print(e);
        emit(ForgotPasswordFailure(error: e.toString()));
      }
    });
  }
}
