import 'package:flutter/material.dart';
import 'package:recruiter_app/features/resdex/data/email_template_repository.dart';
import 'package:recruiter_app/features/resdex/model/email_template_model.dart';

class EmailTemplateProvider extends ChangeNotifier {
  bool isLoading = false;
  List<EmailTemplateModel>? emailTemplate;
  bool isError = false;

  Future<String> createTemplate({required EmailTemplateModel template}) async {
    try {
      isLoading = true;
      notifyListeners();
      final result = await EmailTemplateRepository()
          .createEmailTemplate(template: template);


      if (result != null && result == "success") {
        isLoading = false;
        fetchEmailTemplates();
        notifyListeners();
        return "success";
      } else {
        isLoading = false;
        notifyListeners();
        return result.toString();
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return e.toString();
    }
  }

  Future<void> fetchEmailTemplates() async {
    isLoading = true;
    notifyListeners();
    try {
      final result = await EmailTemplateRepository().fetchEmailTemplate();

      if (result != null) {
        emailTemplate = result;
        isLoading = false;
        notifyListeners();
      } else {
        isError = true;
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      print(e);
      isError = true;
      isLoading = false;
      notifyListeners();
    }
  }

  // Future<List<EmailTemplateModel>?> fetchingEmailTemplates() async {
  //   isLoading = true;
  //   notifyListeners();
  //   try {
  //     final result = await EmailTemplateRepository().fetchEmailTemplate();

  //     if (result != null) {
  //       emailTemplate = result;
  //       isLoading = false;
  //       notifyListeners();
  //       return result;
  //     } else {
  //       isError = true;
  //       isLoading = false;
  //       notifyListeners();
  //       return null;
  //     }
  //   } catch (e) {
  //     print(e);
  //     isError = true;
  //     isLoading = false;
  //     notifyListeners();
  //     return null;
  //   }
  // }




  Future<String?> updateTemaplte({required EmailTemplateModel template}) async {
    try {
      isLoading = true;
      notifyListeners();
      final result = await EmailTemplateRepository()
          .updateEmailTemplate(template: template);

      if (result != null && result == "success") {
        isLoading = false;
        notifyListeners();
        return "success";
      } else {
        isLoading = false;
        notifyListeners();
        return result.toString();
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return e.toString();
    }
  }




  Future<String?> deleteTemplate({required int id}) async {
    try {
      final result =
          await EmailTemplateRepository().deleteEmailTemplate(id: id);
      print(result);
      if (result == "success") {
        fetchEmailTemplates();
        return result;
      } else {
        return result;
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
