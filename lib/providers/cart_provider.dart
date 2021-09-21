import 'package:flutter/foundation.dart';
import 'package:homecook/models/cart.dart';
import 'package:homecook/models/cart_item.dart';
import 'package:homecook/models/order.dart';
import 'package:homecook/models/order_item.dart';
import 'package:homecook/utilities/globals.dart';

class CartProvider extends ChangeNotifier {
  Cart _cart = Cart([]);

  Cart get cart => _cart;

  List<CartItem> get cartItems => _cart.cartItems;

  getCartItem(item) {
    for (var cartItem in _cart.cartItems) {
      if (cartItem.item.id == item.id) {
        return cartItem;
      }
    }
    return null;
  }

  List get groupedOrders {
    List res = [];
    List userIds = cartItems.map((cartItem) => cartItem.item.user.id).toList();
    List uniqueUserIds = Set.from(userIds).toList();
    for (var user_id in uniqueUserIds) {
      List userCartItems = cartItems
          .where((cartItem) => cartItem.item.user.id == user_id)
          .toList();
      res.add(
        Order(
          chef: userCartItems[0].item.user,
          user: loggedInUser,
          orderItems: userCartItems
              .map((e) => OrderItem(
                    item: e.item,
                    quantity: e.quantity,
                  ))
              .toList(),
        ),
      );
    }
    return res;
  }

  void createIfNotFound(item) {
    if (getCartItem(item) == null) {
      addCartItem(CartItem(item, 0));
    }
  }

  void addCartItem(cartItem) {
    _cart.cartItems.add(cartItem);
    notifyListeners();
  }

  void updateCartItem(cartItem) {
    CartItem foundCartItem = getCartItem(cartItem.item);
    if (cartItem.quantity == 0) {
      removeCartItem(cartItem);
    } else if (foundCartItem == null) {
      addCartItem(cartItem);
    } else {
      foundCartItem.quantity = cartItem.quantity;
      notifyListeners();
    }
  }

  void removeCartItem(cartItemToBeDeleted) {
    var cartItem = getCartItem(cartItemToBeDeleted.item);
    if (cartItem != null) _cart.cartItems.remove(cartItem);
    notifyListeners();
  }

  void resetCart() {
    _cart = Cart([]);
    notifyListeners();
  }
}
