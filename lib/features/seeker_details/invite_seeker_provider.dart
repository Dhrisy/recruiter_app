import 'package:flutter/material.dart';
import 'package:recruiter_app/features/seeker_details/invite_repository.dart';

class InviteSeekerProvider extends ChangeNotifier{
  String message = '';
  Future<bool>  inviteCandidate({
    required int candidateId,
    required int jobId
  }) async{
    try {
      final result = await InviteRepository().inviteCandidate(seekerId: candidateId, jobId: jobId);
      if(result == "success"){
        return true;
      }else{
        message = result.toString();
        notifyListeners();
        return false;
      }
    } catch (e) {
      message = e.toString();
      return false;
    }
  }
}