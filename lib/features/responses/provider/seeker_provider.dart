import 'package:flutter/material.dart';
import 'package:recruiter_app/features/resdex/data/seeker_repository.dart';
import 'package:recruiter_app/features/resdex/model/seeker_model.dart';

class SeekerProvider extends ChangeNotifier{
  bool isLoading = false;
  Future<List<SeekerModel>?>? seekerLists;

void setLoading(bool val){
  isLoading = val;
  notifyListeners();
}

  Future<void>  fetchAllAppliedSeekers({String? jobId}) async{
     isLoading = true;
     notifyListeners();
    try {
     
      final result =  SeekerRepository().fetchAllAppliedSeekers(jobId: jobId);
      print("Response of provider $result");
      seekerLists = result;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      throw Exception(e);
    }
  }



  
}