import 'package:flutter/material.dart';
import 'package:homecook/apis/orders.dart';
import 'package:homecook/components/drawer.dart';
import 'package:homecook/components/loader.dart';
import 'package:homecook/models/order.dart';
import 'package:homecook/models/order_item.dart';
import 'package:homecook/utilities/convertor.dart';
import 'package:homecook/utilities/globals.dart';

class RecievedOrdersScreen extends StatefulWidget {
  static const routeName = '/recieved-orders-screen';
  @override
  _RecievedOrdersScreenState createState() => _RecievedOrdersScreenState();
}

class _RecievedOrdersScreenState extends State<RecievedOrdersScreen> {
  bool _processed = false;
  List _orders = [];

  @override
  void initState() {
    super.initState();
    OrdersApi().fetchOthersOrders().then((ords) {
      setState(() {
        _orders = ords;
        _processed = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
          'Recieved Orders',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontFamily: 'Lato',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      drawer: DrawerMenu(context: context),
      body: _processed ? buildBody(context) : Loader(),
    );
  }

  Widget buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, right: 8, left: 8),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _orders.length,
              itemBuilder: (BuildContext cntxt, int index) {
                Order order = _orders[index];
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
                              onTap: () {},
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: 7,
                      left: 12,
                      child: Text(
                        order.user.name.toString(),
                        style: TextStyle(
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Lato',
                        ),
                      ),
                    ),
                    Positioned(
                      top: 7,
                      right: 12,
                      child: Text(
                        formatTimestamp(order.createdAt),
                        style: TextStyle(
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          color: Theme.of(context).colorScheme.onSurface,
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
    );
  }
}
