import 'package:flutter/material.dart';
import 'package:recruiter_app/features/notifications/notification_model.dart';
import 'package:recruiter_app/features/notifications/notification_repository.dart';

class NotificationProvider with ChangeNotifier {
  final NotificationRepository _notificationRepository =
      NotificationRepository();

  List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Fetch notifications
  Future<void> fetchNotifications() async {
    _setLoadingState(true);

    try {
      final fetchedNotifications =
          await _notificationRepository.getNotifications();
      _notifications = fetchedNotifications;
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      _setLoadingState(false);
    }
  }

  // Delete a specific notification
  Future<void> deleteNotification(int notificationId) async {
    _setLoadingState(true);

    try {
      await _notificationRepository
          .removeNotifications(notificationId); // Ensure this method exists
      _notifications
          .removeWhere((notification) => notification.id == notificationId);
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      _setLoadingState(false);
    }
  }

  // Clear all notifications
  // Future<void> clearAllNotifications() async {
  //   _setLoadingState(true);

  //   try {
  //     await _notificationRepository.clearAllNotifications(); // Ensure this method exists
  //     _notifications = [];
  //   } catch (e) {
  //     _setErrorMessage(e.toString());
  //   } finally {
  //     _setLoadingState(false);
  //   }
  // }

  // Helper methods
  void _setLoadingState(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }
}