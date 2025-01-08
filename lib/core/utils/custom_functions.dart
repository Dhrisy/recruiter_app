import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:recruiter_app/services/api_lists.dart';

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

    static String toSentenceCase(String input) {
    if (input.isEmpty) return input;

    // Convert first letter to uppercase and the rest to lowercase
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }


   static String? validateUrl(String? url) {
    const String baseUrl = ApiLists.imageBaseUrl;

    if (url == null || url.isEmpty) {
      return null;
    }

    Uri? uri;
    try {
      uri = Uri.parse(url);
      if (!uri.hasScheme) {
        url = url.startsWith('/') ? url.substring(1) : url;
        url = baseUrl + url;
        uri = Uri.parse(url);
      }
      if (uri.hasScheme && (uri.hasAuthority || uri.host.isNotEmpty)) {
        return url;
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}
