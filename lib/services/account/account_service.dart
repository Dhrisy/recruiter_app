import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:recruiter_app/core/utils/custom_functions.dart';
import 'package:recruiter_app/features/account/account_data.dart';
import 'package:recruiter_app/services/api_lists.dart';

class AccountService {
  final _storage = FlutterSecureStorage();

  static Future<http.Response> fetchAccountDetails() async {
    final token = await CustomFunctions().retrieveCredentials("access_token");
    final url = Uri.parse(ApiLists.companyDetailAddEndPoint);
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer ${token.toString()}',
    });

    return response;
  }

  static Future<http.Response> editAccountData({required AccountData account}) async {
    final url = Uri.parse(ApiLists.editComapany);
    final token = await CustomFunctions().retrieveCredentials("access_token");

    final response = await http.patch(url,
        body: jsonEncode({
          "id": account.id,
          "name": account.name,
          // "logo":  account.logo,
          "about": account.about,
          "website": account.website,
          "functional_area": account.functionalArea,
          "address": account.address,
          "city": account.city,
          "country": account.country,
          "postal_code": account.postalCode,
          "contact_name": account.contactName,
          "contact_land_number": account.contactLandNumber,
          "contact_mobile_number": account.contactMobileNumber,
          "designation": account.designation
        }),
        headers: {
          'Authorization': 'Bearer ${token.toString()}',
        });

    print(response.statusCode);
    print(response.body);
    return response;
  }

   static Future<http.Response> fetchRecruiterCounts() async {
    final token = await CustomFunctions().retrieveCredentials("access_token");
    final url = Uri.parse(ApiLists.recruiterCountsEndPoint);
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer ${token.toString()}',
    });

    return response;
  }
}
