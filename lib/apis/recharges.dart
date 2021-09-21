import 'package:dio/dio.dart';
import 'package:homecook/models/recharge.dart';
import 'package:homecook/utilities/env.dart';
import 'package:homecook/utilities/globals.dart';

class RechargesApi {
  Dio _dio = Dio(
    BaseOptions(
      baseUrl: serverUrl,
      contentType: Headers.jsonContentType,
      headers: {
        'authorization': userToken,
      },
    ),
  );

  Future<Recharge> createRecharge(Recharge recharge) async {
    final Response response = await _dio.post(
      'recharges',
      data: {
        'recharge': {
          'amount': recharge.amount,
          'razorpay_signature': "recharge.signature",
          'razorpay_payment_id': "recharge.paymentId",
          'razorpay_order_id': "recharge.orderId",
          'razorpay_status': recharge.status,
          'razorpay_method': recharge.method,
          'razorpay_datetime': recharge.createdAt,
          'user_id': recharge.uid,
        }
      },
    );

    if (response.statusCode == 201) {
      return Recharge.fromJson(response.data);
    } else {
      throw Exception('Failed to create recharge.');
    }
  }

  Future<Recharge> fetchRecharge(int id) async {
    final Response response = await _dio.get(
      'recharges/' + id.toString(),
    );
    if (response.statusCode == 200) {
      return Recharge.fromJson(response.data);
    } else {
      throw Exception('Failed to find recharge.');
    }
  }

  Future<List> fetchRechargeHistory() async {
    final Response response = await _dio.get(
      'recharges/own',
    );
    if (response.statusCode == 200) {
      return response.data
          .map((jsonItem) => Recharge.fromJson(jsonItem))
          .toList();
    } else {
      throw Exception('Failed to find recharge.');
    }
  }
}
