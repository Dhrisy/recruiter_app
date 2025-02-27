import 'package:http/http.dart' as http;
import 'package:recruiter_app/core/utils/custom_functions.dart';
import 'package:recruiter_app/services/api_lists.dart';

class ResumeService {
  static Future<http.Response> downloadResume({required int id}) async {
    final url =
        Uri.parse("${ApiLists.downloadResumeEndPoint}?application_id=$id");

    final token = await CustomFunctions().retrieveCredentials("access_token");

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer ${token.toString()}',
    });

    return response;
  }
}
