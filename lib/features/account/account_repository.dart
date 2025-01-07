import 'dart:convert';

import 'package:recruiter_app/features/account/account_data.dart';
import 'package:recruiter_app/services/account/account_service.dart';

class AccountRepository {
  Future<AccountData?> fetchAccountDetails() async {
    try {
      final response = await AccountService.fetchAccountDetails();

      print(
          "Response of account fetching ${response.statusCode},  ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        AccountData accountData = AccountData.fromJson(responseData);

        return accountData;
      }else{
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
