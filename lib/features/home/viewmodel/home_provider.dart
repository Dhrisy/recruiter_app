import 'package:flutter/material.dart';
import 'package:recruiter_app/features/home/data/home_repository.dart';

class HomeProvider extends ChangeNotifier{

  Future<void>  fetchRecruiterCounts() async{
    try {
   await HomeRepository().fetchRecruiterCounts();
    } catch (e) {
      
    }
  }
}