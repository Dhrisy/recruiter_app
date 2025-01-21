import 'package:flutter/foundation.dart';
import 'package:recruiter_app/features/resdex/data/seeker_repository.dart';
import 'package:recruiter_app/features/resdex/model/seeker_model.dart';

class SearchSeekerProvider extends ChangeNotifier {
  List<SeekerModel>? seekersLists  = [];
  SeekerEmploymetModel? seekerEmploymentData;
  SeekerPersonalModel? seekerPersonalData;
  SeekerQualificationModel? seekerQualificationData;
  String error = '';
  bool isLoading = false;
  bool searchResultEmpty = false;
  bool isSaved = false;
  bool isSerach = false;
  List<SeekerModel> bookmarkedSeekers = [];



  void setSaved(bool val){
    isSaved = val;
    notifyListeners();
  }

  // experience options

  Future<void> fetchAllSeekersLists() async {
    isLoading = true;
    notifyListeners();
    try {
      final result = await SeekerRepository().fetchAllSeekers();
      if (result != null) {
        seekersLists = result;
        isLoading = false;
        searchResultEmpty = false;
        notifyListeners();
      } else {
         isLoading = false;
        error = "error";
        notifyListeners();
      }
    } catch (e) {
      error = "error";
      isLoading = false;
      searchResultEmpty = false;
      notifyListeners();
    }
  }

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
      final response = await SeekerRepository().searchSeeker(
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

      seekersLists = response;
      if (seekersLists != null && seekersLists!.isEmpty) {
        searchResultEmpty = true;
        isLoading = false;
        notifyListeners();
      } else {
        searchResultEmpty = false;
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      seekersLists = null;
      isLoading = false;
      notifyListeners();
      print("Error occurred: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> toggleSaveCandidate({required String id}) async {
    try {
      // Fetch the current saved candidates list
      final savedCandidateLists = await fetchSavedCandidatesLists();

      bool isAlreadySaved = savedCandidateLists
              ?.any((item) => item.personalData?.personal.id == id) ??
          false;

      // Perform save or remove based on the current state
      final result = await SeekerRepository().saveCandidate(id: id);

      if (result == true) {
        if (isAlreadySaved) {
          // Remove from saved
          isSaved = false;
          isSeekerSaved(id);
        } else {
          // Add to saved

          isSaved = true;
          isSeekerSaved(id);
        }

        notifyListeners();
        return isSaved;
      } else {
        return false;
      }
    } catch (e) {
      print("Error $e");
      isSaved = false;
      notifyListeners();
      return false;
    }
  }

  Future<List<SeekerModel>?> fetchSavedCandidatesLists() async {
    try {
      final result = await SeekerRepository().fetchSavedCandidate();

      if (result != null) {
        bookmarkedSeekers = result;
        notifyListeners();
        return bookmarkedSeekers;
      } else {
        return null;
      }
    } catch (e) {
      print("error $e");
      return null;
    }
  }

  // Check if a seeker exists in the list
  Future<bool> isSeekerSaved(String id) async {
    List<SeekerModel>? savedSeekersLists = await fetchSavedCandidatesLists();
    return savedSeekersLists != null
        ? savedSeekersLists.any((item) {
            if (item.personalData != null) {
              return item.personalData!.personal.id == id;
            }
            return false;
          })
        : false;
  }
}
