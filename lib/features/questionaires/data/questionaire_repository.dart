import 'package:recruiter_app/features/questionaires/model/questionaire_model.dart';
import 'package:recruiter_app/services/company_services.dart';
import 'package:recruiter_app/services/refresh_token_service.dart';

class QuestionaireRepository {
  Future<String?> questionaireSubmission(
      {required QuestionaireModel questionaire}) async {
    try {

      final response =
          await CompanyServices.questionaireSubmit(questionaire: questionaire);

      print(
          "Response of questionaire ${response.statusCode},  ${response.body}");

      if (response.statusCode == 201) {
        return "Success";
      } else if (response.statusCode == 401) {
      await  RefreshTokenService.refreshToken();
        final response = await CompanyServices.questionaireSubmit(
            questionaire: questionaire);
        if (response.statusCode == 201) {
          return "success";
        }
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
}
