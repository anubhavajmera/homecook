import 'dart:async';

import 'package:dio/dio.dart';
import 'package:homecook/models/user.dart';
import 'package:homecook/services/auth.dart';
import 'package:homecook/utilities/env.dart';
import 'package:homecook/utilities/globals.dart';

class UsersApi {
  Dio _dio = Dio(
    BaseOptions(
      baseUrl: serverUrl,
      contentType: Headers.jsonContentType,
      headers: {
        'authorization': userToken,
      },
    ),
  );

  Future<User> createUser(User user) async {
    final Response response = await _dio.post('users', data: {
      'user': {
        'name': user.name,
        'email': user.email,
        'password': user.uid,
        'photo_url': user.photoUrl,
        'phone_number': user.phoneNumber,
        'device_id': deviceId
      }
    });

    if (response.statusCode == 201) {
      return User.fromJson(response.data);
    } else {
      throw Exception('Failed to create user.');
    }
  }

  Future<User> updateUser(User user) async {
    final Response response = await _dio.patch(
      'users/' + user.id.toString(),
      data: {
        'user': {
          'balance': user.balance,
          'name': user.name,
          'address': user.address,
          'photo_url': user.photoUrl,
          'phone_number': user.phoneNumber,
          'latitude': user.latitude,
          'longitude': user.longitude,
        }
      },
    );

    if (response.statusCode == 200) {
      return User.fromJson(response.data);
    } else {
      throw Exception('Failed to update user.');
    }
  }

  Future<User> updateDeviceId(User user, String deviceId) async {
    final Response response = await _dio.patch(
      'users/' + user.id.toString(),
      data: {
        'user': {'device_id': deviceId}
      },
    );

    if (response.statusCode == 200) {
      return User.fromJson(response.data);
    } else {
      throw Exception('Failed to update user.');
    }
  }

  Future fetchAndStoreUserToken(User user) async {
    final Response response = await _dio.post('users/token', data: {
      "auth": {
        "email": user.email,
        "password": user.uid,
      }
    });
    if (response.statusCode == 201) {
      var res = response.data;
      userToken = res['jwt'];
      return userToken;
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<User> fetchCurrentUser() async {
    final Response response = await _dio.get(
      'users/current',
      options: Options(
        headers: {'authorization': userToken},
      ),
    );
    if (response.statusCode == 200) {
      return User.fromJson(response.data);
    } else {
      throw Exception('Failed to find user.');
    }
  }

  Future fetchOrCreateUser(User tempUser) {
    Completer c = Completer();
    fetchAndStoreUserToken(tempUser).then((token) {
      fetchCurrentUser().then((user) => c.complete(user));
    }).catchError((e) {
      if (e.response.statusCode == 404) {
        createUser(tempUser).then((user) {
          fetchAndStoreUserToken(tempUser);
          c.complete(user);
        });
      } else {
        AuthService().signOut();
        throw Exception('Failed to initialize user.');
      }
    });
    return c.future;
  }
}
