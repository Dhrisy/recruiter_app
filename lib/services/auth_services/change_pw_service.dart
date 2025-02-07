import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:recruiter_app/core/utils/custom_functions.dart';
import 'package:recruiter_app/services/api_lists.dart';

class ChangePwService {
  static Future<http.Response> editUser({required String password}) async {
    final url = Uri.parse(ApiLists.editUser);

    final token = await CustomFunctions().retrieveCredentials("access_token");

    final response = await http
        .patch(url, body: jsonEncode({"password": password}), headers: {
      'Authorization': 'Bearer ${token.toString()}',
      'Content-Type': 'application/json',
    });

    return response;
  }

  static Future<http.Response> changePwByForgotPw(
      {required String password,
      required String phone,
      required String otp}) async {
    final url = Uri.parse(ApiLists.changePassword);

    final token = await CustomFunctions().retrieveCredentials("access_token");

    final response = await http.post(url,
        body: jsonEncode(
            {"password": password, "otp": int.parse(otp), "phone": phone}),
        headers: {
          'Content-Type': 'application/json',
        });

    return response;
  }
}
