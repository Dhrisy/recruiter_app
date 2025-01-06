import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:recruiter_app/core/utils/custom_functions.dart';
import 'package:recruiter_app/services/api_lists.dart';

class AccountService {
  final _storage = FlutterSecureStorage();

  static Future<http.Response> fetchAccountDetails() async {
    final token = await CustomFunctions().retrieveCredentials("access_token");
    final url = Uri.parse(ApiLists.companyEndPoint);
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer ${token.toString()}',
    });

    return response;
  }
}
