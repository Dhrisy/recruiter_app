import 'package:http/http.dart' as http;
import 'package:recruiter_app/core/utils/custom_functions.dart';

class PlanService {
  final String baseUrl = 'https://job.emergiogames.com/api/common/all_plans';

// In plan_service.dart
Future<http.Response> fetchPlans() async {
  final accessToken = await CustomFunctions().retrieveCredentials("access_token");

  try {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );
    
    // Add these debug prints
    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    
    return response;
  } catch (e) {
    print('Error in fetchPlans service: $e');
    throw Exception('Failed to load plans: $e');
  }
}
}