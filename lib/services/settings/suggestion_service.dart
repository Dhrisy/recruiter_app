import 'dart:convert';

import 'package:recruiter_app/core/utils/custom_functions.dart';
import 'package:http/http.dart' as http;
import 'package:recruiter_app/services/api_lists.dart';

class SuggestionService {

  Future<bool> sendFeedback(String suggestion) async {
    try {
      final accessToken =
          await CustomFunctions().retrieveCredentials("access_token");
      final response = await http.post(
        Uri.parse(ApiLists.suggestionEndPoint),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: json.encode({'suggestion': suggestion}),
      );

      print(response.statusCode);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return true; // Feedback sent successfully
      } else {
        print('Failed to send feedback: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error sending feedback: $e');
      return false;
    }
  }
}