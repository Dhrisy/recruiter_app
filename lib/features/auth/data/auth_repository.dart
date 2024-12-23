import 'dart:convert';
import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:recruiter_app/core/utils/custom_functions.dart';
import 'package:recruiter_app/services/login_service.dart';
import 'package:recruiter_app/services/register_service.dart';

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

      if (responseData.containsKey("message") &&
          responseData["message"] == "User already exists") {
        return responseData["message"];
      } else if (responseData.containsKey("access")) {
        return "success";
      }
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
}
