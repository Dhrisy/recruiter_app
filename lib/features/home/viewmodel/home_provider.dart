import 'package:flutter/material.dart';
import 'package:recruiter_app/features/home/data/home_repository.dart';
import 'package:recruiter_app/features/home/model/banner_model.dart';
import 'package:recruiter_app/features/home/model/count_model.dart';

class HomeProvider extends ChangeNotifier {
  CountModel? countData;

  List<BannerModel>? bannersLists;
  String bannerMessage = '';

  Future<void> fetchRecruiterCounts() async {
    try {
      countData = await HomeRepository().fetchRecruiterCounts();
      print(countData);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchBanners() async {
    try {
      final result = await HomeRepository().fetchBanners();
      if (result != null) {
        bannersLists = result["list"];
        bannerMessage = result["message"];
        notifyListeners();
      } else {
        bannersLists = null;
        bannerMessage = "error";
        notifyListeners();
      }
    } catch (e) {
      bannersLists = null;
      bannerMessage = e.toString();
      notifyListeners();
    }
  }
}
