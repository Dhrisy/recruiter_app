import 'package:flutter/material.dart';
import 'package:recruiter_app/features/account/account_data.dart';
import 'package:recruiter_app/features/account/account_repository.dart';

class AccountProvider extends ChangeNotifier {
  bool isLoading = false;
  AccountData? accountData;

  Future<void> fetchAccountData() async {
    isLoading = true;
    notifyListeners();
    try {
      final result = await AccountRepository().fetchAccountDetails();

      accountData = result;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      print(e);

      isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> editCompanyDetails({required AccountData account}) async {
    isLoading = true;
    notifyListeners();
    try {
      final result =
          await AccountRepository().editCompanyDetails(accountData: account);
          fetchAccountData();
          isLoading = false;
          notifyListeners();
      return result;
    } catch (e) {
      return e.toString();
    }
  }
}
