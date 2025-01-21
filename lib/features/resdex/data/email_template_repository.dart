import 'dart:convert';

import 'package:recruiter_app/features/resdex/model/email_template_model.dart';
import 'package:recruiter_app/services/email_template_service/email_template_service.dart';
import 'package:recruiter_app/services/refresh_token_service.dart';

class EmailTemplateRepository {
  Future<String?> createEmailTemplate(
      {required EmailTemplateModel template,
      int retryCount = 0,
      int maxRetries = 3}) async {
    try {
      final response =
          await EmailTemplateService.createEmailTemplate(template: template);

      if (response.statusCode == 200) {
        return "success";
      } else if (response.statusCode == 409) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        return responseData["message"];
      } else if (response.statusCode == 401) {
        await RefreshTokenService.refreshToken();
        return createEmailTemplate(
            template: template,
            retryCount: retryCount + 1,
            maxRetries: maxRetries);
      } else {
        return null;
      }
    } catch (e) {
      print("unexpected error $e");
      return null;
    }
  }

  Future<List<EmailTemplateModel>?> fetchEmailTemplate(
      {int retryCount = 0, int maxRetries = 3}) async {
    try {
      final response = await EmailTemplateService.fetchEmailTemplates();
      print(
          "Response of feth email template ${response.statusCode},  ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        List<EmailTemplateModel> templateLists = responseData
            .map((item) => EmailTemplateModel.fromJson(item))
            .toList();
        return templateLists;
      } else if (response.statusCode == 409) {
        return null;
      } else if (response.statusCode == 401) {
        await RefreshTokenService.refreshToken();
        return fetchEmailTemplate(
            retryCount: retryCount + 1, maxRetries: maxRetries);
      } else {
        return null;
      }
    } catch (e) {
      print("unexpected error $e");
      return null;
    }
  }

  Future<String?> updateEmailTemplate(
      {required EmailTemplateModel template,
      int retryCount = 0,
      int maxRetries = 3}) async {
    try {
      final response =
          await EmailTemplateService.editEmailTemplate(template: template);
      print("eidt email ${response.statusCode},  ${response.body}");

      if (response.statusCode == 200) {
        return "success";
      } else if (response.statusCode == 401) {
        await RefreshTokenService.refreshToken();
        return updateEmailTemplate(
            template: template,
            retryCount: retryCount + 1,
            maxRetries: maxRetries);
      } else {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData["message"];
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
