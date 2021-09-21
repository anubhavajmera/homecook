import 'package:dio/dio.dart';
import 'package:homecook/models/order.dart';
import 'package:homecook/models/order_item.dart';
import 'package:homecook/utilities/globals.dart';
import 'package:homecook/utilities/env.dart';

class OrderItemsApi {
  Dio _dio = Dio(
    BaseOptions(
      baseUrl: serverUrl,
      contentType: Headers.jsonContentType,
      headers: {
        'authorization': userToken,
      },
    ),
  );

  Future<OrderItem> createOrderItem(Order order, OrderItem orderItem) async {
    final Response response = await _dio.post(
      'order_items',
      data: {
        'order_item': {
          'item_id': orderItem.item.id,
          'order_id': order.id,
          'quantity': orderItem.quantity,
        }
      },
    );

    if (response.statusCode == 201) {
      return OrderItem.fromJson(response.data);
    } else {
      throw Exception('Failed to create orderItem.');
    }
  }

  Future<OrderItem> fetchOrderItem(int id) async {
    final Response response = await _dio.get(
      'order_items/' + id.toString(),
    );
    if (response.statusCode == 200) {
      return OrderItem.fromJson(response.data);
    } else {
      throw Exception('Failed to find orderItem.');
    }
  }

  Future fetchMyOrderItems() async {
    final Response response = await _dio.get(
      'order_items/own',
    );
    if (response.statusCode == 200) {
      return response.data
          .map((jsonOrderItem) => OrderItem.fromJson(jsonOrderItem))
          .toList();
    } else {
      throw Exception('Failed to find orderItem.');
    }
  }

  Future fetchOthersOrderItems() async {
    final Response response = await _dio.get(
      'order_items/others',
    );
    if (response.statusCode == 200) {
      return response.data
          .map((jsonOrderItem) => OrderItem.fromJson(jsonOrderItem))
          .toList();
    } else {
      throw Exception('Failed to find orderItem.');
    }
  }
}
