import 'package:dio/dio.dart';
import 'package:homecook/models/order.dart';
import 'package:homecook/utilities/env.dart';
import 'package:homecook/utilities/globals.dart';

class OrdersApi {
  Dio _dio = Dio(
    BaseOptions(
      baseUrl: serverUrl,
      contentType: Headers.jsonContentType,
      headers: {
        'authorization': userToken,
      },
    ),
  );

  Future<Order> createOrder(Order order) async {
    final Response response = await _dio.post(
      'orders',
      data: {
        'order': {
          'chef_id': order.chef.id,
          'user_id': order.user.id,
        }
      },
    );

    if (response.statusCode == 201) {
      return Order.fromJson(response.data);
    } else {
      throw Exception('Failed to create order.');
    }
  }

  Future<Order> completeOrder(Order order) async {
    final Response response = await _dio.post(
      'orders/' + order.id.toString() + '/complete_order',
      data: {
        'order': {
          'id': order.id,
        }
      },
    );

    if (response.statusCode == 200) {
      return Order.fromJson(response.data);
    } else {
      throw Exception('Failed to create order.');
    }
  }

  Future<Order> createOrderWithOrderItems(Order order) async {
    final Response response = await _dio.post(
      'orders/composite_orders',
      data: {
        'order': {
          'chef_id': order.chef.id,
          'user_id': order.user.id,
        },
        'order_items': order.orderItems
            .map((orderItem) => {
                  'item_id': orderItem.item.id,
                  'quantity': orderItem.quantity,
                })
            .toList()
      },
    );

    if (response.statusCode == 201) {
      return Order.fromJson(response.data);
    } else {
      print(response.data);
      throw Exception('Failed to create order.');
    }
  }

  Future<Order> fetchOrder(int id) async {
    final Response response = await _dio.get(
      'orders/' + id.toString(),
    );
    if (response.statusCode == 200) {
      return Order.fromJson(response.data);
    } else {
      throw Exception('Failed to find order.');
    }
  }

  Future fetchMyOrders() async {
    final Response response = await _dio.get(
      'orders/own',
    );
    if (response.statusCode == 200) {
      return response.data
          .map((jsonOrder) => Order.fromJson(jsonOrder))
          .toList();
    } else {
      throw Exception('Failed to find order.');
    }
  }

  Future fetchOthersOrders() async {
    final Response response = await _dio.get(
      'orders/others',
    );
    if (response.statusCode == 200) {
      return response.data
          .map((jsonOrder) => Order.fromJson(jsonOrder))
          .toList();
    } else {
      throw Exception('Failed to find order.');
    }
  }
}
