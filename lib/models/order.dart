import 'package:homecook/models/order_item.dart';
import 'package:homecook/models/user.dart';

class Order {
  int id, userId, chefId;
  User chef;
  User user;
  String createdAt;
  List orderItems;
  bool delivered;

  Order({
    this.id,
    this.userId,
    this.chefId,
    this.user,
    this.chef,
    this.createdAt,
    this.orderItems,
    this.delivered,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['user_id'],
      user: User.fromJson(json['user']),
      chefId: json['chef_id'],
      chef: User.fromJson(json['chef']),
      delivered: json['delivered'],
      createdAt: json['created_at'],
      orderItems:
          json['order_item_list'].map((oi) => OrderItem.fromJson(oi)).toList(),
    );
  }
}
