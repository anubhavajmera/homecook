import 'package:flutter/material.dart';
import 'package:homecook/apis/orders.dart';
import 'package:homecook/models/order.dart';
import 'package:homecook/screens/placed_orders.dart';
import 'package:homecook/utilities/map.dart';

class OrderDeliverySheet extends StatelessWidget {
  final Order order;

  OrderDeliverySheet({
    Key key,
    this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              'Order Delivery',
              style: TextStyle(
                fontFamily: 'Lato',
                fontSize: 24,
              ),
            ),
          ),
        ),
        Divider(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Chef info : ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              Text(''),
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(order.chef.photoUrl),
                ),
                title: Text(order.chef.name),
                subtitle: Text(order.chef.address),
                trailing: IconButton(
                  icon: Icon(Icons.directions),
                  onPressed: () {
                    launchMap(order.chef.location, 'Chef', "Chef's Addrees");
                  },
                ),
              ),
            ],
          ),
        ),
        Divider(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Disclaimer : ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              Text(''),
              Text('* Once delivered order is completed.'),
              Text('* After delivery payment can not be reversed.'),
              Text('* Ensure delivery on site only.'),
            ],
          ),
        ),
        Spacer(),
        Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: order.delivered
                    ? FlatButton(
                        child: Text(
                          'Already delivered !',
                          textScaleFactor: 1.2,
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        color: Theme.of(context).accentColor,
                        textColor: Theme.of(context).colorScheme.onPrimary,
                        onPressed: () => {Navigator.pop(context)},
                      )
                    : FlatButton(
                        child: Text(
                          'Mark as delivered',
                          textScaleFactor: 1.2,
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        color: Theme.of(context).colorScheme.secondary,
                        textColor: Theme.of(context).colorScheme.onSecondary,
                        onPressed: () => _processDelivery(context),
                      ),
              ),
            ),
          ],
        )
      ],
    );
  }

  _processDelivery(context) {
    OrdersApi().completeOrder(order).whenComplete(() {
      Navigator.pushReplacementNamed(context, PlacedOrdersScreen.routeName);
    });
  }
}
