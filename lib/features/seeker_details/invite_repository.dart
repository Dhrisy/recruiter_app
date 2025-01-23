import 'dart:convert';

import 'package:recruiter_app/services/seeker_services/seeker_service.dart';

class InviteRepository {
  Future<String?>  inviteCandidate({
    required int seekerId,
    required int jobId,
     int retryCount = 0,
    int maxRetries = 3,
  }) async{
    try {
      final response = await SeekerService.sentInviteCandidate(jobId: jobId, seekerId: seekerId);
      print("Invite seeker response ${response.statusCode}, ${response.body}");
      if(response.statusCode == 200){
        return "success";
      }else if(response.statusCode == 401){
        return inviteCandidate(seekerId: seekerId, jobId: jobId,
        retryCount: retryCount + 1,
          maxRetries: maxRetries,);
      }else{
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData["message"];
      }

    } catch (e) {
      return e.toString();
    }
  }
}