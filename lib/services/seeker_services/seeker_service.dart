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

  static Future<http.Response> saveSeeker({required int id}) async {
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

  // fetch invited candidates
  static Future<http.Response> fetchInvitedCandidates() async {
    final url = Uri.parse(ApiLists.candidateInvitedEndpoint);

    final accessToken =
        await CustomFunctions().retrieveCredentials("access_token");

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer ${accessToken.toString()}',
      'Content-Type': 'application/json',
    });

    return response;
  }


// sent invitation
static Future<http.Response>  sentInviteCandidate({required int jobId, required int seekerId}) async{
  final url = Uri.parse(ApiLists.inviteEndpoint);

    final accessToken =
        await CustomFunctions().retrieveCredentials("access_token");

    final response = await http.post(url, 
    body: jsonEncode({
      "candidate_id": seekerId,
      "job_id": jobId
    }),
    headers: {
      'Authorization': 'Bearer ${accessToken.toString()}',
      'Content-Type': 'application/json',
    });

    return response;

}

// delete invite
static Future<http.Response> deleteInvitedCandidate({required int id}) async{
  final url = Uri.parse("${ApiLists.candidateInvitedEndpoint}?id=$id");
final accessToken =
        await CustomFunctions().retrieveCredentials("access_token");

    final response = await http.delete(url, 
   
    headers: {
      'Authorization': 'Bearer ${accessToken.toString()}',
      'Content-Type': 'application/json',
    });

    return response;


}




// schedule interview
static Future<http.Response>  scheduleInterviewCandidate({required int jobId, required int seekerId, required String date }) async{
  final url = Uri.parse(ApiLists.scheduleInterviewEndpoint);

    final accessToken =
        await CustomFunctions().retrieveCredentials("access_token");

    final response = await http.post(url, 
    body: jsonEncode({
      "candidate_id": seekerId,
      "job_id": jobId,
      "schedule": date
    }),
    headers: {
      'Authorization': 'Bearer ${accessToken.toString()}',
      'Content-Type': 'application/json',
    });

    return response;

}
  
}
