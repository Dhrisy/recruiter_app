import 'package:flutter/material.dart';
import 'package:recruiter_app/features/auth/data/auth_repository.dart';
import 'package:recruiter_app/features/plans/data/plan_repository.dart';
import 'package:recruiter_app/features/settings/model/subscription_model.dart';

class PlanProvider extends ChangeNotifier {
  final PlanRepository _planRepository = PlanRepository();

  List<PlanModel> _plans = [];
  List<PlanModel> get plans => _plans;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> fetchPlans() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _plans = await _planRepository.fetchAllPlans();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  // Optional: Method to get plans by type (Resdex or Job Posting)
  List<PlanModel> getPlansByType(bool isResdex) {
    return _plans.where((plan) => plan.resdex == isResdex).toList();
  }

  Future<String?> subscribePlan({
    required int planId,
      required String phone,
      required String transactionId}) async {
    try {
      final result = await PlanRepository().subscribePlan(
          planId: planId, phone: phone, transactionId: transactionId);
      return result;
    } catch (e) {
      return null;
    }
  }
}
