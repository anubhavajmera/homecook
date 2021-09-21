import 'package:dio/dio.dart';
import 'package:homecook/models/item.dart';
import 'package:homecook/utilities/globals.dart';
import 'package:homecook/utilities/env.dart';

class ItemsApi {
  Dio _dio = Dio(
    BaseOptions(
      baseUrl: serverUrl,
      contentType: Headers.jsonContentType,
      headers: {
        'authorization': userToken,
      },
    ),
  );

  Future<Item> createItem(Item item) async {
    final Response response = await _dio.post(
      'items',
      data: {
        'item': {
          'name': item.name,
          'description': item.description,
          'preparation_time': item.preparationTime,
          'price': item.price,
          'quantity': item.quantity,
          'is_veg': item.isVeg
        }
      },
    );

    if (response.statusCode == 201) {
      return Item.fromJson(response.data);
    } else {
      throw Exception('Failed to create item.');
    }
  }

  Future<Item> fetchItem(int id) async {
    final Response response = await _dio.get(
      'items/' + id.toString(),
    );
    if (response.statusCode == 200) {
      return Item.fromJson(response.data);
    } else {
      throw Exception('Failed to find item.');
    }
  }

  Future fetchMyItems() async {
    final Response response = await _dio.get(
      'items/own',
    );
    if (response.statusCode == 200) {
      return response.data.map((jsonItem) => Item.fromJson(jsonItem)).toList();
    } else {
      throw Exception('Failed to find item.');
    }
  }

  Future fetchOthersItems() async {
    final Response response = await _dio.get(
      'items/others',
    );
    if (response.statusCode == 200) {
      return response.data.map((jsonItem) => Item.fromJson(jsonItem)).toList();
    } else {
      throw Exception('Failed to find item.');
    }
  }
}
