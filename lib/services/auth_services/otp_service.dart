import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:recruiter_app/services/api_lists.dart';

class OtpService {
  Future<http.Response> emailOtpVerify({required String otp, required String email}) async {
    final url = Uri.parse(ApiLists.emailOtpVerifyEndPoint);

    final response = await http.post(
      url,
      body: jsonEncode({"otp": otp, "email": email}),
      headers: {
        "Content-Type": "application/json",
      },
    );

    return response;
  }

 Future<http.Response> emailSentOtp({required String email}) async {
    final url = Uri.parse(ApiLists.emailSentOtpEndPoint);

    final response = await http.post(
      url,
      body: jsonEncode({"email": email}),
      headers: {
        "Content-Type": "application/json",
      },
    );

    return response;
  }
 static Future<http.Response>  retryOtp({required String phone}) async{
    final url = Uri.parse(ApiLists.mobileOtpRetryEndPoint);
    final response = await http.post(url,
    body: jsonEncode({
      "phone": phone
    }));

    print("Response of retyr otp  ${response.statusCode},  ${response.body}");

    return response;
  }
}
