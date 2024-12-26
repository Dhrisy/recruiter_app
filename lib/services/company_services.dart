import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:recruiter_app/features/questionaires/model/questionaire_model.dart';
import 'package:recruiter_app/services/api_lists.dart';

class CompanyServices {
  static final _storage = FlutterSecureStorage();
  static Future<http.Response> questionaireSubmit(
      {required QuestionaireModel questionaire}) async {
    final accessToken = await _storage.read(key: "access_token");
    final url = Uri.parse("https://job.emergiogames.com/api/company/");

    print(accessToken);
    final response = await http.post(url,
        headers: {
          'Authorization': 'Bearer ${accessToken.toString()}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "logo": "string",
          "about": questionaire.about.toString(),
          "website": questionaire.website.toString(),
          "functional_area": questionaire.functionalArea.toString(),
          "address": [questionaire.address.toString()],
          "city": questionaire.city.toString(),
          "country": questionaire.country.toString(),
          "postal_code": questionaire.postalCode.toString(),
          "contact_name": questionaire.contactPersonName.toString(),
          "contact_land_number": questionaire.landlineNumber.toString(),
          "contact_mobile_number": questionaire.mobileNumber.toString(),
          "designation": questionaire.designation.toString()
        }));

    return response;
  }
}
