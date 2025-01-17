import 'package:flutter/material.dart';
import 'package:recruiter_app/features/resdex/data/seeker_repository.dart';
import 'package:recruiter_app/features/resdex/model/seeker_model.dart';

class SeekerProvider extends ChangeNotifier{
  bool isLoading = false;
  List<SeekerModel>? seekerLists;


  Future<void>  fetchAllAppliedSeekers({String? jobId}) async{
    try {
      final result = await SeekerRepository().fetchAllAppliedSeekers(jobId: jobId);
      print("Response of provider $result");
    } catch (e) {
      
    }
  }



  
}