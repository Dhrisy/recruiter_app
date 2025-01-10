import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:recruiter_app/core/utils/custom_functions.dart';
import 'package:recruiter_app/services/api_lists.dart';

class SearchSeekerService {
  Future<http.Response> searchSeeker({
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
    final token = await CustomFunctions().retrieveCredentials("access_token");

    final queryParams = Uri(queryParameters: {
      "keywords": keyWords,
      "experience_year": experienceYear,
      "experience_month": experienceMonth,
      "cuurent_loc": location,
      "nationality": nationality,
      "salary_min": miniSalary,
      "salary_max": maxiSalary,
      "gender": gender,
      "additional": education
    }).query;

    final url = Uri.parse("${ApiLists.resdexSeekersEndPoint}?$queryParams");
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer ${token.toString()}',
    });

    return response;
  }
}
