import 'package:http/http.dart' as http;
import 'package:recruiter_app/core/utils/custom_functions.dart';
import 'package:recruiter_app/features/resdex/model/job_response_model.dart';
import 'package:recruiter_app/services/api_lists.dart';

class ResponseSeekerService {
  static Future<http.Response> editResponse({required int jobId}) async {
    final url =
        Uri.parse("${ApiLists.updateJobApplications}?applied_id=$jobId");

    final token = await CustomFunctions().retrieveCredentials("access_token");
    final response = await http.patch(url, headers: {
      'Authorization': 'Bearer ${token.toString()}',
      'Content-Type': 'application/json',
    });

    return response;
  }
}
