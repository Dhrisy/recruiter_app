import 'package:flutter/foundation.dart';
import 'package:recruiter_app/features/resdex/data/seeker_repository.dart';
import 'package:recruiter_app/features/resdex/model/seeker_model.dart';

class SearchSeekerProvider extends ChangeNotifier {
  List<SeekerModel> seekersLists = [];
  SeekerEmploymetModel? seekerEmploymentData;
  SeekerPersonalModel? seekerPersonalData;
  SeekerQualificationModel? seekerQualificationData;
  String error = '';
    bool isLoading = true;


  Future<void> fetchAllSeekersLists() async {
    
    try {
      final result = await SeekerRepository().fetchAllSeekers();
      if (result != null) {
        seekersLists = result;
        isLoading = false;
        notifyListeners();
      }else{
        error = "error";
      }
      
    } catch (e) {
      error = "error";
      isLoading = false;
      notifyListeners();
    }
  }
}
