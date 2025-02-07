// import 'dart:convert';

// import 'package:http/http.dart' as http;
// import 'package:recruiter_app/services/api_lists.dart';

// class PlansServices {
//   static Future<http.Response> fetchPlans() async{
//     final url = Uri.parse(ApiLists.allPlansEndPoint);

//     final response = await http
//         .patch(url, body: jsonEncode({"password": password}), headers: {
//       'Authorization': 'Bearer ${token.toString()}',
//       'Content-Type': 'application/json',
//     });

//     return response;
//   }
// }