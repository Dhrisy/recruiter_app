import 'dart:convert';
import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:recruiter_app/core/utils/custom_functions.dart';
import 'package:recruiter_app/services/auth_services/forgot_pw_service.dart';
import 'package:recruiter_app/services/auth_services/login_service.dart';
import 'package:recruiter_app/services/auth_services/register_service.dart';

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



  // Future<String?>  forgotPw({required String phone}) async{
  //   try {
  //     final response = await ForgotPwService().forgotPw(phone: phone);
      
  //   // Handle the success response
  //   if (response.statusCode == 200) {
      
  //   }

  //   // Handle unauthorized error and retry only for 401
  //   if (response.statusCode == 401 && retryCount < maxRetries) {
  //     print("Unauthorized (401). Refreshing token and retrying...");
  //     await RefreshTokenService.refreshToken();
  //     return fetchPostedJobs(retryCount: retryCount + 1, maxRetries: maxRetries); // Recursive call for 401
  //   }

  //   // Handle other failure cases
  //   print("Failed to fetch jobs. Status: ${response.statusCode}");
  //   return null;
  //   } catch (e) {
      
  //   }
  // }
}
