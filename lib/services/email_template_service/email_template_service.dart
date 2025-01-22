import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:recruiter_app/core/utils/custom_functions.dart';
import 'package:recruiter_app/features/resdex/model/email_template_model.dart';
import 'package:recruiter_app/services/api_lists.dart';

class EmailTemplateService {
  static Future<http.Response> createEmailTemplate(
      {required EmailTemplateModel template}) async {
    final url = Uri.parse(ApiLists.createEmailTemaplteEndPoint);

    final accessToken =
        await CustomFunctions().retrieveCredentials("access_token");

    final response = await http.post(url,
        body: jsonEncode({
          "name": template.templateName,
          "subject": template.subject,
          "body": template.body,
          "job_id": template.jobId,
          "email": template.email
        }),
        headers: {
          'Authorization': 'Bearer ${accessToken.toString()}',
          'Content-Type': 'application/json',
        });

    return response;
  }

  static Future<http.Response> fetchEmailTemplates() async {
    final url = Uri.parse(ApiLists.fetchEmailTemplated);

    final accessToken =
        await CustomFunctions().retrieveCredentials("access_token");

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer ${accessToken.toString()}',
      'Content-Type': 'application/json',
    });

    return response;
  }

  static Future<http.Response> editEmailTemplate(
      {required EmailTemplateModel template}) async {
    final url = Uri.parse("${ApiLists.updateEmailTemplated}?id=${template.id}");
    final accessToken =
        await CustomFunctions().retrieveCredentials("access_token");

    final response = await http.patch(
      url,
      body: jsonEncode({
        "name": template.templateName,
        "email": template.email,
        "job": "22",
        "subject": template.subject,
        "body": template.body,
      }),
      headers: {
        'Authorization': 'Bearer ${accessToken.toString()}',
        'Content-Type': 'application/json',
      },
    );

    return response;
  }

  static Future<http.Response> deleteEmailTemplate({required int id}) async {
    final url = Uri.parse("${ApiLists.deleteEmailTemplated}?id=$id");
    final accessToken =
        await CustomFunctions().retrieveCredentials("access_token");

    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer ${accessToken.toString()}',
        'Content-Type': 'application/json',
      },
    );

    return response;
  }
}
