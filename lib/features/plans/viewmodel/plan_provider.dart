import 'package:flutter/material.dart';
import 'package:recruiter_app/features/auth/data/auth_repository.dart';
import 'package:recruiter_app/features/settings/model/subscription_model.dart';

class PlanProvider extends ChangeNotifier {
  List<PlanModel>? plansLists;

  Future<List<PlanModel>?> fetchAllRecruiterPlans() async {
    print("qqqqqqqqq");
    try {
      final result = await AuthRepository().fetchAllRecruiterPlans();
      // if (result != null) {
      //   plansLists = result[""];
      //   notifyListeners();
      // }else{
      //   final 
      // }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
