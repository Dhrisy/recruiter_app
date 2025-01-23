



import 'package:flutter/material.dart';
import 'package:recruiter_app/features/resdex/data/seeker_repository.dart';
import 'package:recruiter_app/features/resdex/model/seeker_model.dart';

class SearchSeekerProvider extends ChangeNotifier {
  // List<SeekerModel>? seekersLists = [];
  String error = '';
  bool isLoading = false;
  Map<String, bool> bookmarkedStates = {};
  // List<SeekerModel> bookmarkedSeekerLists = [];
  Future<List<SeekerModel>?>? bookMarkedLists;
  bool searchResultEmpty = false;
  Future<List<SeekerModel>?>? lists;

  /// Fetch all seekers list and initialize bookmarked states
  Future<void> fetchAllSeekersLists() async {
    isLoading = true;
    notifyListeners();
    try {
      final result =  SeekerRepository().fetchAllSeekers();
      if (result != null) {
        // seekersLists = result;
        lists = result;
        await initializeBookmarkedStates(); // Initialize bookmarked states after fetching seekers
        error = '';
      } else {
        error = "Error fetching seekers.";
      }
    } catch (e) {
      error = "Error: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // fetch invited candidate
  Future<void>  fetchInvitedCandidates() async{
    try {
      final result = SeekerRepository().fetchAllInvitedSeekers();
      lists = result;
    } catch (e) {
      throw Exception(e);
    }
  }

  /// Initialize bookmarked states for seekers
  Future<void> initializeBookmarkedStates() async {
    final seekersLists = await lists;
    if (seekersLists != null) {
      for (var seeker in seekersLists!) {
        final id = seeker.personalData?.personal.id.toString();
        if (id != null) {
          final isSaved = await isSeekerSaved(id);
          bookmarkedStates[id] = isSaved;
        }
      }
      notifyListeners();
    }
  }

  /// Toggle bookmark status for a seeker
  Future<void> toggleBookmark(SeekerModel seekerData) async {
    final id = seekerData.personalData?.personal.id.toString();
    if (id != null) {
      final isCurrentlySaved = bookmarkedStates[id] ?? false;
      final result = await toggleSaveCandidate(id: id);
      if (result) {
        bookmarkedStates[id] = !isCurrentlySaved;
      }
      notifyListeners();
    }
  }

  Future<bool> toggleSaveCandidate({required String id}) async {
    try {
      final isSaved = await isSeekerSaved(id);
      if (isSaved) {
        final result = await SeekerRepository().saveCandidate(id: id);
        await fetchSavedCandidatesLists();
        return result ?? false;
      } else {
        final result = await SeekerRepository().saveCandidate(id: id);
         await fetchSavedCandidatesLists();
        return result ?? false;
      }
    } catch (e) {
      print("Error toggling save candidate: $e");
      return false;
    }
  }

  Future<bool> isSeekerSaved(String id) async {
    try {
      final savedCandidates = await fetchSavedCandidatesLists();
      return savedCandidates
              ?.any((seeker) => seeker.personalData?.personal.id == id) ??
          false;
    } catch (e) {
      return false;
    }
  }

  Future<List<SeekerModel>?> fetchSavedCandidatesLists() async {
    try {
      final lists =  SeekerRepository().fetchSavedCandidate();
      // bookmarkedSeekerLists = lists ?? [];
      bookMarkedLists = lists;
      notifyListeners();
      return lists;
    } catch (e) {
      print("Error fetching saved candidates: $e");
      return null;
    }
  }


void changeSearchResult(bool val){
  searchResultEmpty = val;
  notifyListeners();
}
  // search seeker
    Future<void> searchSeeker({
    required List<String> keyWords,
    String? experienceYear,
    String? experienceMonth,
    String location = '',
    String nationality = '',
    String? miniSalary,
    String? maxiSalary,
    String gender = '',
    String education = '',
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      final response =  SeekerRepository().searchSeeker(
        keyWords: keyWords,
        education: education,
        experienceMonth: experienceMonth == "" ? "0" : experienceMonth ?? "0",
        experienceYear: experienceYear == "" ? "0" : experienceYear ?? "0",
        gender: gender,
        location: location,
        maxiSalary: maxiSalary == "" ? "0" : maxiSalary ?? "0",
        miniSalary: miniSalary == "" ? "0" : miniSalary ?? "0",
        nationality: nationality,
      );

      print("Response of search  ${response},");

      lists = response;
      if (lists != null) {
        // searchResultEmpty = true;
        isLoading = false;
        notifyListeners();
      } else {
        // searchResultEmpty = false;
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      lists = null;
      isLoading = false;
      notifyListeners();
      print("Error occurred: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
