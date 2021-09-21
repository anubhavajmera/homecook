import 'package:homecook/models/item.dart';

class CartItem {
  int quantity;
  Item item;

  double totalPrice() {
    return item.price * quantity;
  }

  CartItem(
    this.item,
    this.quantity,
  );
}
