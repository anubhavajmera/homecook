import 'package:homecook/models/cart_item.dart';

class Cart {
  List<CartItem> cartItems;

  double totalPrice() {
    double price = 0;
    cartItems.forEach((element) {
      price += element.totalPrice();
    });
    return price;
  }

  Cart(this.cartItems);
}
