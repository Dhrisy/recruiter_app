import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CustomFunctions {
  final _secureStorage = const FlutterSecureStorage();

  Future<void> storeCredentials(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> retrieveCredentials(String key) async {
    final accessToken = await _secureStorage.read(
        key: "access_token"); // Use await to read securely
    print("isLoggedIn: ${accessToken != null},  $accessToken"); // Debugging log
    return accessToken;
  }

   bool isValidEmail(String email) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }
}
