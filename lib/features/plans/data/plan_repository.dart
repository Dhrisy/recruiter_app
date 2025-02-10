import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recruiter_app/features/settings/model/subscription_model.dart';
import 'package:recruiter_app/services/plans/plans_service.dart';

class PlanRepository {
  final PlanService _planService = PlanService();

  // In plan_repository.dart
  Future<List<PlanModel>> fetchAllPlans() async {
    try {
      final response = await _planService.fetchRecruiterPlans();

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        List<PlanModel> plans = body.map((dynamic item) {
          return PlanModel.fromJson(item);
        }).toList();
        return plans;
      } else {
        throw Exception(
            'Failed to load plans. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Raw error in fetchAllPlans: $e');
      throw Exception('Error in fetching plans: $e');
    }
  }

// subscribe plan
  Future<String?> subscribePlan(
      {required int planId,
      required String phone,
      required String transactionId}) async {
    try {
      final response = await PlanService.subscribePlan(
          planId: planId, phone: phone, transactionId: transactionId);
      if (response.statusCode == 201) {
        return "success";
      } else {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        return responseData["message"];
      }
    } catch (e) {
      return null;
    }
  }
}
