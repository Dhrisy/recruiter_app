import 'dart:convert';

import 'package:recruiter_app/features/resdex/model/seeker_model.dart';
import 'package:recruiter_app/services/seeker_services/seeker_service.dart';

class SeekerRepository {
  // Future<List<SeekerModel>?> fetchAllSeekers() async {
  //   try {
  //     final response = await SeekerService.fetchAllSeekers();
  //     print(
  //         "Response of fetch all seekers ${response.statusCode},  ${response.body}");
  //     if (response.statusCode == 200) {
  //       final List<dynamic> responseData = jsonDecode(response.body);
  //       // Map the response data to SeekerModel
  //       List<SeekerModel> seekerData = responseData.map((item) {
         
  //         return SeekerModel(
  //           personalData: item["personal"] != null
  //               ? SeekerPersonalModel.fromJson(item["personal"])
  //               : null,
  //           employmentData: (item["employment"] as List<dynamic>?)
  //               ?.map((employment) => SeekerEmploymetModel.fromJson(employment))
  //               .toList(),
  //           qualificationData: (item["qualification"] as List<dynamic>?)
  //               ?.map((qualification) =>
  //                   SeekerQualificationModel.fromJson(qualification))
  //               .toList(),
  //         );
  //       }).toList();

  //       return seekerData;
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {
  //     print("unexpected error $e");
  //     return null;
  //   }
  // }


  Future<List<SeekerModel>?> fetchAllSeekers() async {
    try {
      final response = await SeekerService.fetchAllSeekers();
      print(
          "Response of fetch all seekers ${response.statusCode},  ${response.body}");
      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);

        // Use SeekerModel.fromJson to directly convert each item
        List<SeekerModel> seekerData = responseData
            .map((item) => SeekerModel.fromJson(item))
            .toList();

        return seekerData;
      } else {
        return null;
      }
    } catch (e) {
      print("Unexpected error: $e");
      return null;
    }
  }


}
