import 'package:flutter/material.dart';
import 'package:recruiter_app/features/plans/data/plans_repository.dart';
import 'package:recruiter_app/features/plans/model/plan_model.dart';

class PlanProvider with ChangeNotifier {
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
}