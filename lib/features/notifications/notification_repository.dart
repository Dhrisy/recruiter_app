import 'dart:convert';

import 'package:recruiter_app/features/notifications/notification_model.dart';
import 'package:recruiter_app/features/notifications/notification_service.dart';
import 'package:recruiter_app/services/refresh_token_service.dart';

class NotificationRepository {
  Future<dynamic> getNotifications() async {
    try {
      final response = await NotificationServices.fetchNotifications();
      print(
          "Data Response ----> Notification API ===>  ++ ${response.statusCode} ${response.body} ");
      if (response.statusCode == 401) {
        await RefreshTokenService.refreshToken();
        final response = await NotificationServices.fetchNotifications();
        print("Redefined Response: $response");
      }
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        print("Data Response ----> Notification API ===> $jsonData");
        return jsonData
            .map((data) => NotificationModel.fromJson(data))
            .toList();
      } else {
        throw Exception(
            "Error fetching Notifications : ${response.reasonPhrase}");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> removeNotifications(int notiId) async {
    try {
      final response = await NotificationServices.deleteNotifications(notiId);
      print(
          "Data Response ----> Notification Delete ===>  ++ ${response.statusCode} ${response.body} ");
      if (response.statusCode == 401) {
        await RefreshTokenService.refreshToken();
        final response = await NotificationServices.deleteNotifications(notiId);
        print("Redefined Response: $response");
      }
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        print("Data Response ---->  Notification Delete ===> $jsonData");
        return jsonData;
      } else {
        throw Exception(
            "Error in Delete Notifications : ${response.reasonPhrase}");
      }
    } catch (e) {
      rethrow;
    }
  }
}