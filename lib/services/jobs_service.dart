import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:recruiter_app/core/utils/custom_functions.dart';
import 'package:recruiter_app/core/utils/skills.dart';
import 'package:recruiter_app/features/job_post/model/job_post_model.dart';
import 'package:recruiter_app/features/responses/view/response.dart';
import 'package:recruiter_app/services/api_lists.dart';

class JobsService {
  static Future<http.Response?> jobPost({required JobPostModel job}) async {
    final url = Uri.parse(ApiLists.jobPostEndPoint);
    final accessToken =
        await CustomFunctions().retrieveCredentials("access_token");

    print("access token $accessToken");

    try {
      final response = await http.post(url,
          body: jsonEncode({
            "title": job.title,
            "description": job.description,
            "type": job.jobType,
            "category": "",
            "city": job.city,
            "country": job.country,
            "vacancy": job.vaccancy,
            "industry": job.industry,
            "functional_area": job.functionalArea,
            "gender": job.gender,
            "nationality": job.nationality,
            "experience_min": job.minimumExperience,
            "experience_max": job.maximumExperience,
            "candidate_location": job.candidateLocation,
            "education": job.education,
            "salary_min": job.minimumSalary,
            "salary_max": job.maximumSalary,
            "skills": job.skills,
            "custom-qns": job.customQuestions,
            "requirements": "job.requirements",
            "benefits": "job.benefits",
            "roles": "",
            "currency": job.currency
          }),
          headers: {
            'Authorization': 'Bearer ${accessToken.toString()}',
            'Content-Type': 'application/json',
          });


      return response;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<http.Response> fetchPostedJobs() async {
    final url = Uri.parse(ApiLists.jobPostEndPoint);
    final accessToken =
        await CustomFunctions().retrieveCredentials("access_token");

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer ${accessToken.toString()}',
    });

    return response;
  }

  static Future<http.Response> editJobPost({required JobPostModel job}) async {
    final url = Uri.parse(ApiLists.updateJobPostEndPoint);
    final token = await CustomFunctions().retrieveCredentials("access_token");

    print("iiiiiii ${job.id}");
    final response = await http.patch(url,
        body: jsonEncode({
          "id": job.id,
          "title": job.title,
          "description": job.description,
          "type": job.jobType,
          "category": "",
          "city": job.city,
          "country": job.country,
          "vacancy": job.vaccancy,
          "industry": job.industry,
          "functional_area": job.functionalArea,
          "gender": job.gender,
          "nationality": job.nationality,
          "experience_min": job.minimumExperience,
          "experience_max": job.maximumExperience,
          "candidate_location": job.candidateLocation,
          "education": job.education,
          "salary_min": job.minimumSalary,
          "salary_max": job.maximumSalary,
          "skills": job.skills,
          "custom-qns": job.customQuestions,
          "requirements": "job.requirements",
          "benefits": "job.benefits",
          "roles": "",
          "currency": job.currency
        }),
         headers: {
            'Authorization': 'Bearer ${token.toString()}',
            'Content-Type': 'application/json',
          }
        );

    return response;
  }
}
