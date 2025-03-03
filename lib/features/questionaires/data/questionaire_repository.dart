import 'dart:io';

import 'package:recruiter_app/features/questionaires/model/questionaire_model.dart';
import 'package:recruiter_app/services/account/company_services.dart';
import 'package:recruiter_app/services/refresh_token_service.dart';

class QuestionaireRepository {
  Future<String?> questionaireSubmission(
      {required QuestionaireModel questionaire,
      int? retryCount = 0,
      int? maxRetries = 3}) async {
    try {
      print("ffff   ${questionaire.logo}");
      final response =
          await CompanyServices.questionaireSubmit(questionaire: questionaire);

      print(
          "Response of questionaire ${response.statusCode},  ${response.body}");

      if (response.statusCode == 201) {
        return "success";
      } else if (response.statusCode == 401) {
        await RefreshTokenService.refreshToken();
        return questionaireSubmission(
            questionaire: questionaire,
            maxRetries: maxRetries,
            retryCount: retryCount! + 1);
        // final response = await CompanyServices.questionaireSubmit(
        //     questionaire: questionaire);
        // if (response.statusCode == 201) {
        //   return "success";
        // }
      } else if (response.statusCode == 409) {
        return "error";
      } else {
        return "Something went wrong!";
      }
    } catch (e) {
      print("Response of questionaire  catch error$e");
      return null;
    }
  }

  Future<String?> logoPosting({required File? image}) async {
    try {
      final response = await CompanyServices.logoPost(image: image);
      var responseBody = await response.stream.bytesToString();

      print("Response of logo ${response.statusCode},  ${responseBody}");

      if (response.statusCode == 200) {
        return "success";
      } else {
        return "Failed to upload logo";
      }
    } catch (e) {
      print("Response of logo  catch error$e");
      return null;
    }
  }
}
