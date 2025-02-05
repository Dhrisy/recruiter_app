import 'package:flutter/foundation.dart';
import 'package:recruiter_app/features/auth/data/auth_repository.dart';

class LoginProvider extends ChangeNotifier {
  final AuthRepository authRepository;

  // Constructor to initialize the AuthRepository
  LoginProvider({required this.authRepository});

  bool otpSuccess = false;
  bool isLoading = false;
  String error = '';

  void setOtpSuccess(bool value) {
    otpSuccess = value;
    notifyListeners();
  }

  // Future<bool?> mobileLogin({required String phone}) async {
  //   try {
  //     final result = await authRepository.phoneLogin(phone: phone);
  //     print(result);
  //     // Handle success
  //     if (result == "Otp send successfully") {
  //       otpSuccess = true;
  //       notifyListeners();
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } catch (e) {
  //     // Handle errors
  //     if (kDebugMode) {
  //       print("Error during mobile login: $e");
  //     }
  //     return null;
  //   }
  // }

  Future<String?> verifyPhoneOtp(
      {required String phone, required String otp}) async {
    try {
      isLoading = true;
      final result =
          await authRepository.mobileOtpVerify(phone: phone, otp: otp);

      if (result == "success") {
        isLoading = false;
        notifyListeners();
        return "success";
      } else {
        error = result.toString();
        isLoading = false;
        return result.toString();
      }
    } catch (e) {
      // Handle errors
      if (kDebugMode) {
        print("Error during mobile login: $e");
      }
      return null;
    }
  }

  // change pw
  Future<String?> editUser({required String password}) async {
    isLoading = true;
    notifyListeners();
    try {
      final result = await AuthRepository().editUser(password: password);
      print(result);

      if (result == "success") {
        isLoading = false;
        notifyListeners();
        return "success";
      } else {
        isLoading = false;
        notifyListeners();
        return result;
      }
    } catch (e) {
      print(e);
      isLoading = false;
      notifyListeners();
      return e.toString();
    }
  }

  Future<String?> forgotPasswordGetOtp({required String phn}) async {
    try {
      final result = await AuthRepository().forgotPw(phone: phn);
      if (result == "success") {
        otpSuccess = true;
        notifyListeners();
        return "success";
      } else {
        return result.toString();
      }
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  Future<String?> changePassword(
      {required String phone,
      required String otp,
      required String password}) async {
    try {
      final result = await AuthRepository()
          .changePassword(password: password, phone: phone, otp: otp);
      print(result);

      return result.toString();
    } catch (e) {
      return e.toString();
    }
  }

  Future<bool?> checkSubscriptions() async {
    try {
      final result = await AuthRepository().checkSubscriptions();
      if (result != null && result == true) {
        return true;
      } else if (result != null && result == false) {
        return false;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
