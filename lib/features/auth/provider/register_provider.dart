import 'package:flutter/material.dart';
import 'package:recruiter_app/features/auth/data/auth_repository.dart';

class RegisterProvider  extends ChangeNotifier{
  bool isLoading = false;
  bool otpSuccess = false;


  Future<String?> retryOTP({required String phn}) async {
    try {
      final result = await AuthRepository().resendOTP(phone: phn);
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
  
}