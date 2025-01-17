import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:recruiter_app/core/utils/custom_functions.dart';
import 'package:recruiter_app/services/api_lists.dart';

class ForgotPwService {
  Future<http.Response> forgotPw({required String phone}) async {
    final url = Uri.parse(ApiLists.forgotPwEndPoint);
    
    final response = await http.post(url, 
    body: jsonEncode({
      "phone": phone
    }),
    headers: {
      
      'Content-Type': 'application/json',
    });
    return response;
  }
}
