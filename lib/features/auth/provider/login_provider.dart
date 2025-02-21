import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:recruiter_app/core/utils/custom_functions.dart';
import 'package:recruiter_app/features/auth/data/auth_repository.dart';

class LoginProvider extends ChangeNotifier {
  final AuthRepository authRepository;

  // Constructor to initialize the AuthRepository
  LoginProvider({required this.authRepository});

  bool otpSuccess = false;
  bool isLoading = false;
  String error = '';
  bool sentOTPLoading = false;

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

         final connectivityResult = await CustomFunctions.checkNetworkConnection();
    if(connectivityResult != null){
     isLoading = false;
        notifyListeners();
      return connectivityResult.toString();
    }


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
    sentOTPLoading = true;
    notifyListeners();

    // // Check network connection
    // var connectivityResult = await Connectivity().checkConnectivity();
    // if (connectivityResult.contains(ConnectivityResult.none)) {
    //   sentOTPLoading = false;
    //   notifyListeners();
    //   return "No internet connection. Please check your network.";
    // }

    final connectivityResult = await CustomFunctions.checkNetworkConnection();
    if (connectivityResult != null) {
      sentOTPLoading = false;
        notifyListeners();
      return connectivityResult.toString();
    }

    try {
      final result = await AuthRepository()
          .forgotPw(phone: phn)
          .timeout(const Duration(seconds: 10), onTimeout: () {
        throw TimeoutException("Request timed out. Please check your network.");
      });

      if (result == "success") {
        otpSuccess = true;
        sentOTPLoading = false;
        notifyListeners();
        return "success";
      } else {
        sentOTPLoading = false;
        notifyListeners();
        return result.toString();
      }
    } catch (e) {
      sentOTPLoading = false;
      notifyListeners();
      return e is TimeoutException
          ? "Request timed out. Please check your network."
          : e.toString();
    }
  }

  Future<String?> changePassword({
    required String phone,
    required String otp,
    required String password,
  }) async {
    sentOTPLoading = true;
    notifyListeners();

    // Check network connection
    final connectivityResult = await CustomFunctions.checkNetworkConnection();
   
    if (connectivityResult != null) {
      sentOTPLoading = false;
      notifyListeners();
      return connectivityResult.toString();
    }

    // if (connectivityResult.contains(ConnectivityResult.none)) {
    //   sentOTPLoading = false;
    //   notifyListeners();
    //   return "No internet connection. Please check your network.";
    // }

    try {
      final result = await AuthRepository()
          .changePassword(password: password, phone: phone, otp: otp)
          .timeout(const Duration(seconds: 10), onTimeout: () {
        throw TimeoutException("Request timed out. Please check your network.");
      });

      sentOTPLoading = false;
      notifyListeners();

      return result.toString();
    } catch (e) {
      sentOTPLoading = false;
      notifyListeners();
      return e is TimeoutException
          ? "Request timed out. Please check your network."
          : e.toString();
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
