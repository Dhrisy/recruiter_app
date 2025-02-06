import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recruiter_app/features/plans/model/plan_model.dart';
import 'package:recruiter_app/services/plans/plan_services.dart';

class PlanRepository {
  final PlanService _planService = PlanService();

 // In plan_repository.dart
Future<List<PlanModel>> fetchAllPlans() async {
  try {
    final response = await _planService.fetchPlans();

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      List<PlanModel> plans = body.map((dynamic item) {
        return PlanModel.fromJson(item);
      }).toList();
      return plans;
    } else {
      throw Exception('Failed to load plans. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Raw error in fetchAllPlans: $e');
    throw Exception('Error in fetching plans: $e');
  }
}
}