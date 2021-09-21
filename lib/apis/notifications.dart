import 'package:dio/dio.dart';
import 'package:homecook/models/notification.dart';
import 'package:homecook/utilities/env.dart';
import 'package:homecook/utilities/globals.dart';

class NotificationsApi {
  Dio _dio = Dio(
    BaseOptions(
      baseUrl: serverUrl,
      contentType: Headers.jsonContentType,
      headers: {
        'authorization': userToken,
      },
    ),
  );

  Future fetchMyNotifications() async {
    final Response response = await _dio.get(
      'notifications/own',
    );
    if (response.statusCode == 200) {
      return response.data
          .map((jsonItem) => Notification.fromJson(jsonItem))
          .toList();
    } else {
      throw Exception('Failed to find item.');
    }
  }

  Future<Notification> updateReadStatus(Notification notification) async {
    final Response response = await _dio.patch(
      'notifications/' + notification.id.toString(),
      data: {
        'notification': {'read_status': true}
      },
    );

    if (response.statusCode == 200) {
      return Notification.fromJson(response.data);
    } else {
      throw Exception('Failed to update user.');
    }
  }
}
