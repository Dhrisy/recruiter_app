import 'dart:convert';

import 'package:recruiter_app/features/account/account_data.dart';
import 'package:recruiter_app/services/account/account_service.dart';
import 'package:recruiter_app/services/refresh_token_service.dart';

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
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String?> editCompanyDetails(
      {required AccountData accountData,
      int? retryCount = 0,
      int? maxRetries = 3}) async {
    try {
      final response =
          await AccountService.editAccountData(account: accountData);
      if (response.statusCode == 201) {
        return "success";
      } else if (response.statusCode == 401) {
        await RefreshTokenService.refreshToken();
        return editCompanyDetails(
            accountData: accountData,
            retryCount: retryCount! + 1,
            maxRetries: maxRetries);
      } else {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        return responseData["message"];
      }
    } catch (e) {
      print(e);
      return e.toString();
    }
  }
}
