import 'package:http/http.dart' as http;
import 'package:recruiter_app/core/utils/custom_functions.dart';
import 'package:recruiter_app/services/api_lists.dart';

class SubscribeService {
  static Future<http.Response> fetchSubscriptions() async {
    final url = Uri.parse(ApiLists.fetchSubscriptions);

    final token = await CustomFunctions().retrieveCredentials("access_token");
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer ${token.toString()}',
      'Content-Type': 'application/json',
    });

    return response;
  }
}
