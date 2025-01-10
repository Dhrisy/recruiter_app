import 'dart:convert';

import 'package:recruiter_app/features/resdex/model/seeker_model.dart';
import 'package:recruiter_app/services/seeker_services/search_seeker_service.dart';
import 'package:recruiter_app/services/seeker_services/seeker_service.dart';

class SeekerRepository {
  Future<List<SeekerModel>?> fetchAllSeekers() async {
    try {
      final response = await SeekerService.fetchAllSeekers();
      print(
          "Response of fetch all seekers ${response.statusCode},  ${response.body}");
      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);

        // Use SeekerModel.fromJson to directly convert each item
        List<SeekerModel> seekerData =
            responseData.map((item) => SeekerModel.fromJson(item)).toList();

        return seekerData;
      } else {
        return null;
      }
    } catch (e) {
      print("Unexpected error: $e");
      return null;
    }
  }

  Future<List<SeekerModel>?> searchSeeker({
    required List<String> keyWords,
    int experienceYear = 0,
    int experienceMonth = 0,
    String location = '',
    String nationality = '',
    int miniSalary = 0,
    int maxiSalary = 0,
    String gender = '',
    String education = '',
  }) async {
    try {
      final response = await SearchSeekerService().searchSeeker(
        keyWords: keyWords,
        education: education,
        experienceMonth: experienceMonth,
        experienceYear: experienceYear,
        gender: gender,
        location: location,
        maxiSalary: maxiSalary,
        miniSalary: miniSalary,
        nationality: nationality,
      );

      print("Response of search  ${response.statusCode},  ${response.body}");
    } catch (e) {}
  }
}
