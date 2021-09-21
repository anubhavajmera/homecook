import 'package:flutter/material.dart';
import 'package:homecook/apis/notifications.dart';
import 'package:homecook/components/flushbar_alert.dart';

class NotificationProvider extends ChangeNotifier {
  List _notifications = [];
  int unReadCount = 0;

  get notifications => _notifications;

  set notifications(newNotifications) {
    _notifications = newNotifications;
    notifyListeners();
  }

  void initializeNotifications() {
    NotificationsApi().fetchMyNotifications().then((fetchedItems) {
      notifications = fetchedItems.reversed.toList();
      unreadNotificationCount();
    }).catchError((e) {
      showFlushbarAlert(
        color: Colors.red,
        title: 'Error',
        message: "Unable to fetch notifications.",
      );
      notifications = [];
    });
  }

  void updateReadStatusAt({index, notification}) {
    NotificationsApi().updateReadStatus(notification);
    _notifications[index].readStatus = true;
    unReadCount--;
    notifyListeners();
  }

  void unreadNotificationCount() {
    List list = _notifications
        .where((notification) => notification.readStatus == false)
        .toList();
    unReadCount = list.length;
  }
}
