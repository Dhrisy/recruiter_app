import 'package:http/http.dart' as http;
import 'package:recruiter_app/core/utils/custom_functions.dart';
import 'package:recruiter_app/services/api_lists.dart';

class SeekerService {
  static Future<http.Response> fetchAllSeekers() async {
    final url = Uri.parse(ApiLists.allSeekersEndPoint);
    final accessToken =
        await CustomFunctions().retrieveCredentials("access_token");

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer ${accessToken.toString()}',
      'Content-Type': 'application/json',
    });

    return response;
  }
}
