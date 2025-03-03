import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:recruiter_app/services/api_lists.dart';

class LoginService {
  static Future<http.Response> mobileLoginService({
    required String username,
    
  }) async {
    final url = Uri.parse(ApiLists.mobieLoginEndPoint);
   return await http.post(
        url,
        body: jsonEncode({
          
          
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
          
          "username": email,
          "password": password
          
        }),
        headers: {
          "Content-Type": "application/json",
        },
      );
  }



 

  static Future<http.Response>  mobileOtpVerify({required String phone, required String otp}) async{
    final url = Uri.parse(ApiLists.mobileOtpVerifyEndPoint);
    final response = await http.post(url,
    body: jsonEncode({
      "phone": phone,
      "otp": otp
    }));

    return response;
  }



}
