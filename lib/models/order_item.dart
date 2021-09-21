import 'package:homecook/models/item.dart';

class OrderItem {
  int id, itemId;
  Item item;
  int quantity;
  String createdAt;

  double totalPrice() {
    return item.price * quantity;
  }

  OrderItem({
    this.id,
    this.itemId,
    this.item,
    this.quantity,
    this.createdAt,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      itemId: json['item_id'],
      quantity: json['quantity'],
      createdAt: json['created_at'],
      item: Item.fromJsonWithoutUser(json['item']),
    );
  }
}
