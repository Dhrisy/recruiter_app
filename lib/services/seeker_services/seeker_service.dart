import 'dart:convert';

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

  static Future<http.Response> fetchRespondedSeeker({String? jobId}) async {
    final url = Uri.parse("${ApiLists.respondedSeekerEndPoint}?${jobId ?? ""}");
    final accessToken =
        await CustomFunctions().retrieveCredentials("access_token");

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer ${accessToken.toString()}',
      'Content-Type': 'application/json',
    });

    return response;
  }

  static Future<http.Response> saveSeeker({required String id}) async {
    final url = Uri.parse("${ApiLists.saveCandidateEndPoint}?id=$id");

    final accessToken =
        await CustomFunctions().retrieveCredentials("access_token");

    final response = await http.post(url, headers: {
      'Authorization': 'Bearer ${accessToken.toString()}',
      'Content-Type': 'application/json',
    });

    return response;
  }

  static Future<http.Response> fetchSavedSeeker() async {
    final url = Uri.parse(ApiLists.fetchSaveCandidateEndPoint);

    final accessToken =
        await CustomFunctions().retrieveCredentials("access_token");

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer ${accessToken.toString()}',
      'Content-Type': 'application/json',
    });

    return response;
  }
}
