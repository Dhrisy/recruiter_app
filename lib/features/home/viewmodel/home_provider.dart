import 'package:flutter/material.dart';
import 'package:recruiter_app/features/home/data/home_repository.dart';
import 'package:recruiter_app/features/home/model/count_model.dart';

class HomeProvider extends ChangeNotifier {
  CountModel? countData;

  Future<void> fetchRecruiterCounts() async {
    try {
      countData = await HomeRepository().fetchRecruiterCounts();
      print(countData);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
