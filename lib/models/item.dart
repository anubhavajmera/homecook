import 'dart:math';

import 'package:homecook/models/user.dart';
import 'package:homecook/utilities/globals.dart';

class Item {
  num id, preparationTime, price, quantity, userId;
  String name, description, createdAt;
  bool isVeg;
  User user;

  Item({
    this.id,
    this.preparationTime,
    this.price,
    this.quantity,
    this.userId,
    this.createdAt,
    this.name,
    this.isVeg = true,
    this.description,
    this.user,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      preparationTime: json['preparation_time'],
      price: json['price'],
      quantity: json['quantity'],
      userId: json['user_id'],
      createdAt: json['created_at'],
      name: json['name'],
      isVeg: json['is_veg'],
      description: json['description'],
      user: User.fromJson(json['user']),
    );
  }

  factory Item.fromJsonWithoutUser(json) {
    return Item(
      id: json['id'],
      preparationTime: json['preparation_time'],
      price: json['price'],
      quantity: json['quantity'],
      userId: json['user_id'],
      createdAt: json['created_at'],
      name: json['name'],
      isVeg: json['is_veg'],
      description: json['description'],
    );
  }

  double getDistanceFromUser() {
    double lat2 = loggedInUser.location.latitude;
    double long2 = loggedInUser.location.longitude;
    double lat1 = user.location.latitude;
    double long1 = user.location.longitude;
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((long2 - long1) * p)) / 2;
    return (12742 * asin(sqrt(a)));
  }
}
