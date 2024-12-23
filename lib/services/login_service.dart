import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:recruiter_app/services/api_lists.dart';

class LoginService {
  static Future<http.Response> mobileLoginService({
    required String username,
    required String password,
  }) async {
    final url = Uri.parse(ApiLists.mobieLoginEndPoint);
   return await http.post(
        url,
        body: jsonEncode({
          
          "password": password,
          "username": username,
          
        }),
        headers: {
          "Content-Type": "application/json",
        },
      );
  }

   static Future<http.Response> emailLoginService({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse(ApiLists.emailLoginEndPoint);
   return await http.post(
        url,
        body: jsonEncode({
          
          "password": password,
          "email": email,
          
        }),
        headers: {
          "Content-Type": "application/json",
        },
      );
  }
}
