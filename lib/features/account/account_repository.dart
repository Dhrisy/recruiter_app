import 'dart:convert';

import 'package:recruiter_app/features/account/account_data.dart';
import 'package:recruiter_app/services/account/account_service.dart';
import 'package:recruiter_app/services/refresh_token_service.dart';

class AccountRepository {
  Future<Map<String, dynamic>?> fetchAccountDetails(
      {int? retryCount = 0, int? maxRetries = 3}) async {

        
    try {
      final response = await AccountService.fetchAccountDetails();

      print(
          "Response of account fetching ${response.statusCode},  ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        AccountData accountData = AccountData.fromJson(responseData);
        

        return {"account": accountData, "message": ""};
      } else if (response.statusCode == 401) {
        await RefreshTokenService.refreshToken();
        return fetchAccountDetails(
            retryCount: retryCount! + 1, maxRetries: maxRetries);
      } else {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return {"account": null, "message": responseData["message"]};
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
      return e.toString();
    }
  }

  Future<UserModel?> fetchUserData({
    int? retryCount = 0,
    int? maxRetries = 3,
  }) async {
    try {
      final response = await AccountService.fetchUserData();
      print("user response  ${response.body}");
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        UserModel userData = UserModel.fromJson(responseData);
        return userData;
      } else if (response.statusCode == 401) {
        // await RefreshTokenService.refreshToken();
        // return fetchUserData(
        //     retryCount: retryCount! + 1, maxRetries: maxRetries);
      } else {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData["message"];
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
