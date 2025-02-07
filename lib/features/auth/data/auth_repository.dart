import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:recruiter_app/core/utils/custom_functions.dart';
import 'package:recruiter_app/features/responses/view/response.dart';
import 'package:recruiter_app/features/settings/data/settings_repository.dart';
import 'package:recruiter_app/features/settings/model/subscription_model.dart';
import 'package:recruiter_app/services/auth_services/change_pw_service.dart';
import 'package:recruiter_app/services/auth_services/forgot_pw_service.dart';
import 'package:recruiter_app/services/auth_services/login_service.dart';
import 'package:recruiter_app/services/auth_services/otp_service.dart';
import 'package:recruiter_app/services/auth_services/register_service.dart';
import 'package:recruiter_app/services/plans/plans_service.dart';
import 'package:recruiter_app/services/subscriptions/subscribe_service.dart';

class AuthRepository {
  final _secureStorage = const FlutterSecureStorage();

  Future<String?> register({
    required String companyName,
    required String email,
    required String contactNumber,
    required String password,
    required String role,
    required bool whatsappUpdations,
  }) async {
    try {
      final registerResponse = await RegisterService.register(
          companyName: companyName,
          email: email,
          contactNumber: contactNumber,
          password: password,
          role: role,
          whatsappUpdations: whatsappUpdations);

      print(
          "Register response ${registerResponse.statusCode},  ${registerResponse.body}");
      final Map<String, dynamic> responseData =
          jsonDecode(registerResponse.body);

      if (registerResponse.statusCode == 201) {
        return "success";
      } else if (responseData.containsKey("message") &&
          responseData["message"] == "User already exists") {
        return responseData["message"];
      }

      // if (responseData.containsKey("message") &&
      //     responseData["message"] == "User already exists") {
      //   return responseData["message"];
      // } else if (responseData.containsKey("access")) {
      //   await _secureStorage.write(key: "access_token", value: responseData["access"]);
      //   await _secureStorage.write(key: "refresh_token", value: responseData["refresh"]);

      //   return "success";
      // }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<String?> emailLogin({
    required String email,
    required String password,
  }) async {
    try {
      final response = await LoginService.emailLoginService(
          email: email, password: password);

      print("email login response  ${response.statusCode},   ${response.body}");
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (responseData.containsKey("access")) {
          CustomFunctions().storeCredentials("email", email);
          CustomFunctions()
              .storeCredentials("access_token", responseData["access"]);
          CustomFunctions()
              .storeCredentials("refresh_token", responseData["refresh"]);

          return "success";
        } else if (responseData.containsKey("message")) {
          return responseData["message"];
        } else {
          return "Something went wrong! Please try again later";
        }
      } else if (responseData.containsKey("message")) {
        return responseData["message"];
      }
    } catch (e) {
      print(e);
      return "Something went wrong! Please try again later";
    }
  }

  Future<String?> phoneLogin({required String phone}) async {
    try {
      final response = await LoginService.mobileLoginService(username: phone);
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (response.statusCode == 201) {
        return "success";
      } else {
        return responseData["message"];
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> getPhoneOtp({required String phone}) async {
    try {
      final response = await LoginService.retryOtp(phone: phone);
      print("Get otp auth ${response.statusCode}, ${response.body}");
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return "success";
      } else {
        return responseData["message"];
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> mobileOtpVerify(
      {required String phone, required String otp}) async {
    try {
      final response =
          await LoginService.mobileOtpVerify(phone: phone, otp: otp);

      print(
          'Response of mobilt otp verify ${response.statusCode}, ${response.body}');
      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        CustomFunctions()
            .storeCredentials("access_token", responseData["access"]);
        CustomFunctions()
            .storeCredentials("refresh_token", responseData["refresh"]);

        return "success";
      } else {
        return responseData["message"];
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> forgotPw({required String phone}) async {
    try {
      final response = await ForgotPwService().forgotPw(phone: phone);

      print("Response of forgot pw ${response.statusCode}, ${response.body}");
      Map<String, dynamic> responseData = jsonDecode(response.body);
      // Handle the success response
      if (response.statusCode == 200) {
        return "success";
      } else {
        return responseData["message"];
      }
    } catch (e) {
      print("Unexpected error in forgot password $e");
      return null;
    }
  }

// email sent otp
  Future<String?> emailSentOtp({required String email}) async {
    try {
      final response = await OtpService().emailSentOtp(email: email);
      print(
          "Response of email erify ${response.statusCode},  ${response.body}");
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        await CustomFunctions()
            .storeCredentials("access_token", responseData["access"]);
        await CustomFunctions()
            .storeCredentials("refresh_token", responseData["refresh"]);
        return "success";
      } else {
        return responseData["message"];
      }
    } catch (e) {
      print("unepecte error $e");
      return null;
    }
  }

// email verify
  Future<String?> emailOtpVerify(
      {required String otp, required String email}) async {
    try {
      final response =
          await OtpService().emailOtpVerify(otp: otp, email: email);
      print(
          "Response of email erify ${response.statusCode},  ${response.body}");
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return "success";
      } else {
        return responseData["message"];
      }
    } catch (e) {
      print("unepecte error $e");
      return null;
    }
  }

// change pw
  Future<String?> editUser(
      {required String password,
      int? retryCount = 0,
      int? maxRetries = 3}) async {
    try {
      final response = await ChangePwService.editUser(password: password);

      print("REsponse of change pw  ${response.statusCode},  ${response.body}");
      if (response.statusCode == 200) {
        return "success";
      } else if (response.statusCode == 401) {
        return editUser(
            password: password,
            retryCount: retryCount! + 1,
            maxRetries: maxRetries);
      } else {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        return responseData["message"];
      }
    } catch (e) {
      return null;
    }
  }

// chnage pw by forgot passwrd
  Future<String?> changePassword(
      {required String password,
      required String phone,
      required String otp}) async {
    try {
      final response = await ChangePwService.changePwByForgotPw(
          password: password, phone: phone, otp: otp);
      print("${response.statusCode},   ${response.body}");
      if (response.statusCode == 200) {
        return "success";
      } else {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        return responseData["message"];
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool?> checkSubscriptions() async {
    try {
      final subscriptions = await SettingsRepository().fetchSubscriptions();
      if (subscriptions != null) {
        SubscriptionModel subscribe = subscriptions["subscription"];
        final regExp = RegExp(r'P(\d+)D');
        final match = regExp.firstMatch(subscribe.plan.duration);
        int days = match != null ? int.parse(match.group(1)!) : 0;

        // Adding duration to get end date
        // Get the current date and add duration
        DateTime durationDate = DateTime.now().add(Duration(days: days));

        // Get today's date without time
        DateTime today = DateTime.now();
        String formattedEndDate = DateFormat('yyyy-MM-dd').format(durationDate);

        print("Subscription Ends On: $formattedEndDate");
        // If the subscription is expired, show an alert dialog
        if (today.isAfter(durationDate)) {
          return false;
        } else {
          return true;
        }
      }
    } catch (e) {
      return null;
    }
  }


  Future<Map<String, dynamic>?>  fetchAllRecruiterPlans() async{
    try {
      final response = await PlansService.fetchPlans();
      print("response of fetch all recruiter plans ${response.statusCode},  ${response.body}");

    } catch (e) {
      
    }
  }
}
