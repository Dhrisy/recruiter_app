import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:recruiter_app/core/utils/custom_functions.dart';
import 'package:recruiter_app/services/api_lists.dart';

class PlanService {
  final String baseUrl = 'https://job.emergiogames.com/api/common/all_plans';

// In plan_service.dart
  Future<http.Response> fetchRecruiterPlans() async {
    final accessToken =
        await CustomFunctions().retrieveCredentials("access_token");

    try {
      final response = await http.get(
        Uri.parse(ApiLists.allRecruiterPlansEndPoint),
        headers: {
          // 'Authorization': 'Bearer ${accessToken.toString()}',
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

  // subscribe plan
  static Future<http.Response> subscribePlan(
      {required int planId,
      required String phone,
      required String transactionId}) async {
    try {
      final response = await http.post(
        Uri.parse(ApiLists.subscribeEndPoint),
        body: jsonEncode(
            {"phone": phone, "plan_id": planId, "transaction_id": "string"}),
        headers: {
          // 'Authorization': 'Bearer ${accessToken.toString()}',
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
