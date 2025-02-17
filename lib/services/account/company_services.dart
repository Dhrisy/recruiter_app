// import 'dart:convert';

// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:http/http.dart' as http;
// import 'package:recruiter_app/features/questionaires/model/questionaire_model.dart';
// import 'package:recruiter_app/services/api_lists.dart';

// class CompanyServices {
//   static final _storage = FlutterSecureStorage();
//   static Future<http.Response> questionaireSubmit(
//       {required QuestionaireModel questionaire}) async {
//     final accessToken = await _storage.read(key: "access_token");
//     final url = Uri.parse("https://job.emergiogames.com/api/company/");

//     print(accessToken);
//     final response = await http.post(url,
//         headers: {
//           'Authorization': 'Bearer ${accessToken.toString()}',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({
//           // "logo": questionaire.,
//           "about": questionaire.about.toString(),
//           "website": questionaire.website.toString(),
//           "functional_area": questionaire.functionalArea.toString(),
//           "address": [questionaire.address.toString()],
//           "city": questionaire.city.toString(),
//           "country": questionaire.country.toString(),
//           "postal_code": questionaire.postalCode.toString(),
//           "contact_name": questionaire.contactPersonName.toString(),
//           "contact_land_number": questionaire.landlineNumber.toString(),
//           "contact_mobile_number": questionaire.mobileNumber.toString(),
//           "designation": questionaire.designation.toString()
//         }));

//     return response;
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:recruiter_app/core/utils/custom_functions.dart';
import 'package:recruiter_app/features/questionaires/model/questionaire_model.dart';
import 'package:recruiter_app/services/api_lists.dart';
import 'package:path/path.dart';
import 'package:recruiter_app/services/refresh_token_service.dart';
import 'package:path/path.dart' as path;

class CompanyServices {


static Future<http.Response> questionaireSubmit({
  required QuestionaireModel questionaire,
  int? retryCount = 0,
  int? maxRetries = 3,
}) async {
  try {
    final accessToken = await CustomFunctions().retrieveCredentials("access_token");

    if (accessToken == null) {
      throw Exception("Access token not found");
    }

    final url = Uri.parse("https://job.emergiogames.com/api/company/");

    // Create multipart request
    var request = http.MultipartRequest('POST', url);

    // Add authorization header (DO NOT set Content-Type manually)
    request.headers.addAll({
      'Authorization': 'Bearer ${accessToken.toString()}',
    });

    // Add JSON data correctly
    request.fields["data"] = jsonEncode({
      "about": questionaire.about,
      "website": questionaire.website,
      "functional_area": questionaire.functionalArea,
      "address": [questionaire.address],
      "city": questionaire.city,
      "country": questionaire.country,
      "postal_code": questionaire.postalCode,
      "contact_name": questionaire.contactPersonName,
      "contact_land_number": questionaire.landlineNumber,
      "contact_mobile_number": questionaire.mobileNumber,
      "designation": questionaire.designation,
    });

    // Add file if it exists
    if (questionaire.logo != null && File(questionaire.logo!.path).existsSync()) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'logo',
          questionaire.logo!.path,
          filename: path.basename(questionaire.logo!.path),
        ),
      );
    } else {
      print("Logo file not found or is null");
    }

    // Send the request
    final streamedResponse = await request.send();

    // Convert streamed response to regular response
    final response = await http.Response.fromStream(streamedResponse);
    
    print("Response Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    return response;
  } catch (e) {
    throw Exception("Failed to submit questionnaire: $e");
  }
}


  static Future<http.StreamedResponse> logoPost({required File? image}) async {
    String url =
        "${ApiLists.baseUrl}/company/company/logo"; // Replace with actual API URL
    var request = http.MultipartRequest("POST", Uri.parse(url));
    final token = await CustomFunctions().retrieveCredentials("access_token");
    request.headers.addAll({
      'Authorization': 'Bearer ${token.toString()}',
      "Content-Type": "multipart/form-data",
    });

    request.files.add(
      await http.MultipartFile.fromPath(
        'logo',
        image!.path,
        filename: path.basename(image!.path),
      ),
    );

    var response = await request.send();

    return response;
  }
}
