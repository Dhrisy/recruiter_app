import 'package:http/http.dart' as http;
import 'package:recruiter_app/services/api_lists.dart';

class PlansService {
  static Future<http.Response> fetchPlans() async {
    final url = Uri.parse(ApiLists.allRecruiterPlansEndPoint);
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
    });

    return response;
  }
}
