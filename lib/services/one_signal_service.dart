import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:recruiter_app/core/utils/custom_functions.dart';
import 'package:recruiter_app/services/api_lists.dart';
import 'package:recruiter_app/services/refresh_token_service.dart';

class OneSignalService {
  static Future<bool?> oneSignalService(
      {int? retryCount = 0,
      int? maxRetries = 3,
      required String oneSignalId}) async {
    final url =
        Uri.parse("${ApiLists.oneSignalEndPoint}?onesignal_id=$oneSignalId");

    final accessToken =
        await CustomFunctions().retrieveCredentials("access_token");

    final response = await http.patch(url, headers: {
      'Authorization': 'Bearer ${accessToken.toString()}',
    });
    print(
        "Response of onesignal patch  ${response.statusCode},  ${response.body}");
    if (response.statusCode == 200) {
      print("success");
    } else if (response.statusCode == 401) {
      await RefreshTokenService.refreshToken();
      return oneSignalService(
          oneSignalId: oneSignalId,
          retryCount: retryCount! + 1,
          maxRetries: maxRetries);
    } else {
      print("not success");
    }
  }

  Future<void> oneSIgnalIdSetToApi() async {
    // Request notification permission
    bool hasPermission = await OneSignal.Notifications.requestPermission(true);
    print("Notification Permission Granted: $hasPermission");

    // Add a delay to allow OneSignal to register the device
    await Future.delayed(Duration(seconds: 3));

    // Add basic notification handler
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      print("NOTIFICATION RECEIVED: ${event.notification.title}");
      event.notification.display(); // Display notification
    });
    try {
      // Wait for OneSignal to register the device
      await Future.delayed(Duration(seconds: 2));

      // Fetch device token and subscription details
      final deviceToken = await OneSignal.User.pushSubscription.token;
      final isSubscribed = await OneSignal.User.pushSubscription.optedIn;
      final userId = await OneSignal.User.pushSubscription.id;

      print("OneSignal Device Token: $deviceToken");
      print("User is subscribed: $isSubscribed");
      print("OneSignal User ID: $userId");

      // Save credentials if available
      if (deviceToken != null) {
        await CustomFunctions().storeCredentials("one_signal_id", deviceToken);
        print("Device token saved successfully.");
      }

      if (userId != null) {
        await CustomFunctions().storeCredentials("one_signal_userid", userId);
        final id =
            await CustomFunctions().retrieveCredentials("one_signal_userid");
        print("OneSignal ID Retrieved: $id");
        await OneSignalService.oneSignalService(oneSignalId: id ?? "");
        print("User ID saved successfully.");
      }
    } catch (e) {
      print("Error occurred while retrieving or saving OneSignal data: $e");
    }
  }
}
