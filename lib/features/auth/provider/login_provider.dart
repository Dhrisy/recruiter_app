import 'package:flutter/foundation.dart';
import 'package:recruiter_app/features/auth/data/auth_repository.dart';

class LoginProvider extends ChangeNotifier {
  final AuthRepository authRepository;

  // Constructor to initialize the AuthRepository
  LoginProvider({required this.authRepository});

  bool otpSuccess = false;
  bool isLoading = false;
  String error = '';

  Future<bool?> mobileLogin({required String phone}) async {
    try {
      final result = await authRepository.phoneLogin(phone: phone);
      print(result);
      // Handle success
      if (result == "Otp send successfully") {
        otpSuccess = true;
        notifyListeners();
        return true;
      }else{
         return false;
      }
     
    } catch (e) {
      // Handle errors
      if (kDebugMode) {
        print("Error during mobile login: $e");
      }
      return null;
    }
  }

  Future<bool> verifyPhoneOtp(
      {required String phone, required String otp}) async {
    try {
      isLoading = true;
      final result =
          await authRepository.mobileOtpVerify(phone: phone, otp: otp);

      if (result == "success") {
        isLoading = false;
        notifyListeners();
        return true;
      } else {
        error = result.toString();
        isLoading = false;
        return false;
      }
    } catch (e) {
      // Handle errors
      if (kDebugMode) {
        print("Error during mobile login: $e");
      }
      return false;
    }
  }
}
