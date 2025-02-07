
import 'package:http/http.dart' as http;
import 'package:recruiter_app/core/utils/custom_functions.dart';
import 'package:recruiter_app/services/api_lists.dart';

class NotificationServices {
  static Future<http.Response> fetchNotifications() async {
    final url = Uri.parse(ApiLists.notification);
    final accessToken =
        await CustomFunctions().retrieveCredentials("access_token");
    print('Token  is ${accessToken}');

    try {
      return await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${accessToken.toString()}',
          'Content-Type': 'application/json',
        },
      );
    } catch (e) {
      throw Exception("Failed to fetch notification: $e");
    }
  }

  static Future<http.Response> deleteNotifications(int NotiId) async {
    final url = Uri.parse(ApiLists.deleteNotification);
    final accessToken =
        await CustomFunctions().retrieveCredentials("access_token");

    try {
      return await http.delete(url, headers: {
        'Authorization': 'Bearer ${accessToken.toString()}',
        'Content-Type': 'application/json',
      }, body: {
        "id": NotiId,
      });
    } catch (e) {
      throw Exception("Failed to delete notification: $e");
    }
  }
}