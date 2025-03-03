import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:recruiter_app/core/utils/custom_functions.dart';
import 'package:recruiter_app/features/resdex/data/seeker_repository.dart';
import 'package:recruiter_app/features/resdex/model/invite_seeker_model.dart';
import 'package:recruiter_app/features/resdex/model/seeker_model.dart';
import 'package:recruiter_app/widgets/common_snackbar.dart';

class SearchSeekerProvider extends ChangeNotifier {
  // List<SeekerModel>? seekersLists = [];
  String error = '';
  bool isLoading = false;

  Map<int, bool> bookmarkedStates = {};
  // List<SeekerModel> bookmarkedSeekerLists = [];
  List<SeekerModel>? bookMarkedLists;
  bool searchResultEmpty = false;
  Future<List<SeekerModel>?>? lists;

  Future<List<InvitedSeekerWithJob>?>? invitedLists;
  List<InvitedSeekerWithJob>?  invitedCandidateLists;

  /// Fetch all seekers list and initialize bookmarked states
  Future<void> fetchAllSeekersLists() async {
    isLoading = true;
    notifyListeners();
    try {
      final result = SeekerRepository().fetchAllSeekers();
      if (result != null) {
        // seekersLists = result;
        lists = result;
        await initializeBookmarkedStates(); 
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
  Future<void> fetchInvitedCandidates() async {
    try {
      final result = SeekerRepository().fetchAllInvitedSeekers();
      invitedLists = result;
      notifyListeners();
    } catch (e) {
      throw Exception(e);
    }
  }

  // delete invited candidate
  Future<bool?> deleteInvitedSeeker({required int id}) async {
    try {
      final result = await SeekerRepository().deleteInvitedSeeker(id: id);
      if (result != null && result == "success") {
        fetchInvitedCandidates();
        return true;
      } else {
        error = result.toString();
        notifyListeners();
        return false;
      }
    } catch (e) {
      return null;
    }
  }

  /// Initialize bookmarked states for seekers
  Future<void> initializeBookmarkedStates() async {
    final seekersLists = await lists;
    
    if (seekersLists != null) {
      for (var seeker in seekersLists) {
        final id = seeker.personalData?.personal.id;
        if (id != null) {
          final isSaved = await isSeekerSaved(id);
          bookmarkedStates[id] = isSaved;
        }
      }
      notifyListeners();
    }
  }

  /// Toggle bookmark status for a seeker
  Future<void> toggleBookmark(
      SeekerModel seekerData, BuildContext context) async {
    final id = seekerData.personalData?.personal.id;
    if (id != null) {
      final isCurrentlySaved = bookmarkedStates[id] ?? false;
      final result = await toggleSaveCandidate(id: id, context: context);
      await fetchSavedCandidatesLists();
      if (result) {
        bookmarkedStates[id] = !isCurrentlySaved;
        await fetchSavedCandidatesLists();
      }
      notifyListeners();
    }
  }

  Future<bool> toggleSaveCandidate(
      {required int id, required BuildContext context}) async {
    try {
      final isSaved = await isSeekerSaved(id);
      if (isSaved) {
        final result =
            await SeekerRepository().saveCandidate(id: id, context: context);
        await fetchSavedCandidatesLists();
        return result ?? false;
      } else {
        final result =
            await SeekerRepository().saveCandidate(id: id, context: context);
        await fetchSavedCandidatesLists();
        return result ?? false;
      }
    } catch (e) {
      print("Error toggling save candidate: $e");
      return false;
    }
  }

  Future<bool> isSeekerSaved(int id) async {
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
      final lists = SeekerRepository().fetchSavedCandidate();
      // bookmarkedSeekerLists = lists ?? [];
      bookMarkedLists = await lists;
      notifyListeners();
      return lists;
    } catch (e) {
      print("Error fetching saved candidates: $e");
      return null;
    }
  }

  void changeSearchResult(bool val) {
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
      final response = SeekerRepository().searchSeeker(
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
