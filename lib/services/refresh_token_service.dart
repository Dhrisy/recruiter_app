import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:recruiter_app/services/api_lists.dart';

class RefreshTokenService {
  static final _storage = FlutterSecureStorage();

  static Future<String?> refreshToken() async {
    
    final refreshToken = await _storage.read(key: "refresh_token");

    print("refresh toke : ${refreshToken}");
    try {
      final url = Uri.parse(ApiLists.refreshTokenEndPoint);

      final response = await http.post(
        url,
        body: jsonEncode(
          {"refresh": refreshToken.toString()}
        ),
      );

      print(
          "response of refresh Token ${response.statusCode},  ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        _storage.write(key: "access_token", value: responseData["access"]);
        _storage.write(key: "refresh_token", value: responseData["refresh"]);
        return responseData["access"];
      } else {
        return "";
      }
    } catch (e) {
      print("Unexpected error in refresh token calling $e");
      return null;
    }
  }
}
