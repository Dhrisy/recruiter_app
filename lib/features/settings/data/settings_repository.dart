import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:recruiter_app/features/settings/model/subscription_model.dart';
import 'package:recruiter_app/features/splash_screen/splash_screen.dart';
import 'package:recruiter_app/services/account/account_service.dart';
import 'package:recruiter_app/services/refresh_token_service.dart';
import 'package:recruiter_app/services/subscriptions/subscribe_service.dart';
import 'package:recruiter_app/widgets/common_snackbar.dart';

class SettingsRepository {
  Future<Map<String, dynamic>?> fetchSubscriptions(
      {int? retryCount = 0, int? maxRetries = 3}) async {
    try {
      final response = await SubscribeService.fetchSubscriptions();
      print("Subscription response ${response.statusCode},  ${response.body}");
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        SubscriptionModel subscriptions =
            SubscriptionModel.fromJson(responseData);

        return {"subscription": subscriptions, "message": "success"};
      } else if (response.statusCode == 401) {
        await RefreshTokenService.refreshToken();
        return fetchSubscriptions(
            maxRetries: maxRetries, retryCount: retryCount! + 1);
      } else {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return {"subscription": null, "message": responseData["message"]};
      }
    } catch (e) {
      return null;
    }
  }

  // Method to delete user account
  static Future<String?> deleteUser({
    required BuildContext context,
  }) async {
    try {
      // Call the service to delete the user account
      final response = await AccountService.deleteUser();

      print("Response From Delete User ----> $response");

      // Handle 401 Unauthorized (token expired)
      if (response.statusCode == 401) {
        await RefreshTokenService.refreshToken(); // Refresh the token

        // Retry the request with the new token
        final retryResponse = await AccountService.deleteUser();

        print("Retry Response From Delete User ----> ${retryResponse.body}");

        // Handle the retry response
        if (retryResponse.statusCode == 200 ||
            retryResponse.statusCode == 202) {
               final _storage = FlutterSecureStorage();
                              await _storage.deleteAll();
                              await _storage.write(
                                  key: "user", value: "installed");
          // Show success Snackbar
          CommonSnackbar.show(
           context,
            message: "Account deleted successfully!",
          );



         
          Navigator.pushAndRemoveUntil(
              context, MaterialPageRoute(builder: (context) => SplashScreen()), (Route<dynamic> route) => false);
          return retryResponse.body; // Return the response body as a String
        } else {
          // Show error Snackbar
          CommonSnackbar.show(
            context,
            message: "Failed to delete account after token refresh",
          );

          throw Exception(
              "Failed to delete account after token refresh: ${retryResponse.statusCode} - ${retryResponse.body}");
        }
      }

      // Handle successful response (200 OK or 202 Accepted)
      if (response.statusCode == 200 || response.statusCode == 202) {
        // Show success Snackbar
        CommonSnackbar.show(
        context,
          message: "Account deleted successfully!",
        );
 final _storage = FlutterSecureStorage();
                              await _storage.deleteAll();
                              await _storage.write(
                                  key: "user", value: "installed");
        // Navigate to the login screen or home screen after deletion
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SplashScreen()));
        // Navigator.popUntil(context, (route) => route.isFirst);

        return response.body; // Return the response body as a String
      } else {
        // Show error Snackbar
        CommonSnackbar.show(
         context,
          message: "Failed to delete account. Please try again.",
         
        );

        throw Exception(
            "Failed to delete account: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      // Show error Snackbar for exceptions
      CommonSnackbar.show(
       context,
        message: "An error occurred! Please try again.",
      
      );

      throw Exception("An error occurred in UserRepository: $e");
    }
  }
}
