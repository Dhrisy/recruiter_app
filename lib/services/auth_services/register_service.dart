import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:recruiter_app/services/api_lists.dart';

class RegisterService {
  // static Future<bool?> register({
  //   required String companyName,
  //   required String email,
  //   required String contactNumber,
  //   required String password,
  //   required String role,
  //   required String whatsappUpdations,
  // }) async {
  //   try {
  //     final url = Uri.parse(ApiLists.registerEndPoint);

  //     final response = await http.post(url, body: {
  //       "name": companyName,
  //       "password": password,
  //       "email": email,
  //       "phone": contactNumber,
  //       "username": contactNumber,
  //       "role": "recruiter",
  //       "whatsapp_updations": whatsappUpdations
  //     });

  //     print("Response of register ${response.statusCode}, ${response.body}");
  //   } catch (e) {}
  // }
  static Future<http.Response> register({
    required String companyName,
    required String email,
    required String contactNumber,
    required String password,
    required String role,
    required bool whatsappUpdations,
  }) async {
    
    final url = Uri.parse(ApiLists.registerEndPoint);
   return await http.post(
        url,
        body: jsonEncode({
          "name": companyName,
          "password": password,
          "email": email,
          "phone": contactNumber,
          "role": role,
          "onesignal_id": "f57460e6-1f9e-418a-ab47-c499dce28870",
          "whatsapp_updations": whatsappUpdations.toString()
        }),
        headers: {
          "Content-Type": "application/json",
        },
      );
  }
}
