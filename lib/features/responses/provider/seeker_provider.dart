import 'package:flutter/material.dart';
import 'package:recruiter_app/features/resdex/data/seeker_repository.dart';
import 'package:recruiter_app/features/resdex/model/job_response_model.dart';
import 'package:recruiter_app/features/resdex/model/seeker_model.dart';
import 'package:recruiter_app/features/responses/data/response_repository.dart';
import 'package:recruiter_app/features/responses/view/response.dart';

class SeekerProvider extends ChangeNotifier {
  bool isLoading = false;
  Future<List<JobResponseModel>?>? seekerLists;
  List<JobResponseModel> allSeekers = [];
  List<JobResponseModel> _filteredSeekers = [];
  String message = '';
  String _searchQuery = '';

  List<JobResponseModel> get filteredSeekers => _filteredSeekers;
  String get searchQuery => _searchQuery;

  void setLoading(bool val) {
    isLoading = val;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _filterSeekers();
    notifyListeners();
  }

  void _filterSeekers() {
    if (_searchQuery.isEmpty) {
      _filteredSeekers = List.from(allSeekers);
    } else {
      _filteredSeekers = allSeekers.where((seeker) {
        final name = seeker.seeker.personalData?.user.name?.toLowerCase() ?? '';
        final email =
            seeker.seeker.personalData?.user.email?.toLowerCase() ?? '';
        final phone =
            seeker.seeker.personalData?.user.phoneNumber?.toLowerCase() ?? '';
        final job = seeker.job.title?.toLowerCase() ?? '';
        final query = _searchQuery.toLowerCase();

        return name.contains(query) ||
            email.contains(query) ||
            phone.contains(query) ||
            job.contains(query);
      }).toList();
    }
  }

  Future<void> fetchAllAppliedSeekers({int? jobId}) async {
    isLoading = true;
    notifyListeners();

    try {
      final result = await SeekerRepository().fetchAllAppliedSeekers();
      if (result != null) {
        allSeekers = result;
        _filterSeekers();
        notifyListeners();
      }
      seekerLists = Future.value(result);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      throw Exception(e);
    }
  }

  void clearSearch() {
    _searchQuery = '';
    _filterSeekers();
    notifyListeners();
  }

  Future<bool?> editResponse({required int jobId}) async {
    try {
      final result = await ResponseRepository().editResponse(jobId: jobId);
      print(result);
      if (result == "success") {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
    }
  }
}
