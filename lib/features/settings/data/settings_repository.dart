import 'dart:convert';

import 'package:recruiter_app/features/settings/model/subscription_model.dart';
import 'package:recruiter_app/services/refresh_token_service.dart';
import 'package:recruiter_app/services/subscriptions/subscribe_service.dart';

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
}
