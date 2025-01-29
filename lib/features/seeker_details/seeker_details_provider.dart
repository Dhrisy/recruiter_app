import 'package:flutter/foundation.dart';
import 'package:recruiter_app/features/resdex/data/seeker_repository.dart';
import 'package:recruiter_app/features/resdex/model/seeker_model.dart';

class SeekerDetailsProvider extends ChangeNotifier{
  List<SeekerModel>? seekerLists;


  Future<void>  fetchAppliedJobs({required int id}) async{
    try {
     final result = await SeekerRepository().fetchAllAppliedSeekers();
    } catch (e) {
      
    }

  }
}