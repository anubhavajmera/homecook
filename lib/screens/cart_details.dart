import 'package:flutter/material.dart';
import 'package:homecook/apis/orders.dart';
import 'package:homecook/components/loader.dart';
import 'package:homecook/components/flushbar_alert.dart';
import 'package:homecook/models/order.dart';
import 'package:homecook/models/order_item.dart';
import 'package:homecook/providers/cart_provider.dart';
import 'package:homecook/screens/home.dart';
import 'package:homecook/screens/item_details.dart';
import 'package:homecook/utilities/globals.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  static const String routeName = '/cart-screen';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return buildBody(context);
  }

  Widget buildBody(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    void showStatusDialog() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(child: Text('Placing Order...')),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Loader(),
              ],
            ),
            actions: <Widget>[
              Text(
                "* Do not close this window !!",
                style: TextStyle(fontSize: 12),
              ),
              Text(
                "* Do not turn network off !!",
                style: TextStyle(fontSize: 12),
              )
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 28,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        title: Text(
          'My Cart',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
            fontFamily: 'Lato',
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              inr + cartProvider.cart.totalPrice().toString(),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.only(top: 30, right: 8, left: 8),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartProvider.groupedOrders.length,
                itemBuilder: (BuildContext cntxt, int index) {
                  Order order = cartProvider.groupedOrders[index];
                  return Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 0.75,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          height: 73.0 * order.orderItems.length,
                          child: ListView.builder(
                            itemCount: order.orderItems.length,
                            itemBuilder: (context, index) {
                              OrderItem orderItem = order.orderItems[index];
                              return ListTile(
                                title: Text(orderItem.item.name),
                                subtitle: Text(inr +
                                    orderItem.item.price.toString() +
                                    ' per serving'),
                                leading: CircleAvatar(
                                  child: Text(
                                    orderItem.quantity.toString(),
                                  ),
                                ),
                                trailing: Text(
                                  inr + orderItem.totalPrice().toString(),
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    ItemScreen.routeName,
                                    arguments: orderItem.item,
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        top: 7,
                        left: 12,
                        child: Text(
                          order.chef.name.toString(),
                          style: TextStyle(
                            backgroundColor:
                                Theme.of(context).colorScheme.surface,
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Lato',
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: cartProvider.cart.cartItems.length > 0
          ? Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10,
              ),
              child: RaisedButton(
                child: Text(
                  'Place Orders',
                  textScaleFactor: 1.2,
                ),
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: 16),
                color: Theme.of(context).colorScheme.secondary,
                textColor: Theme.of(context).colorScheme.onSecondary,
                onPressed: () {
                  showStatusDialog();
                  placeOrder(cartProvider);
                },
              ),
            )
          : Text(''),
    );
  }

  void placeOrder(CartProvider cartProvider) {
    for (Order order in cartProvider.groupedOrders) {
      OrdersApi().createOrderWithOrderItems(order).then(
        (placedOrder) {
          cartProvider.resetCart();
          Navigator.popAndPushNamed(context, HomeScreen.routeName);
          showFlushbarAlert(
              context: context,
              title: 'Order Placed',
              message: 'See Placed Orders for details.',
              color: Colors.green);
        },
      ).catchError((e) {
        Navigator.pop(context);
        showFlushbarAlert(
            context: context,
            title: 'Error !',
            message: e.response.data["message"].toString(),
            color: Colors.red);
      });
    }
  }
}
