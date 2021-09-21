import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:homecook/components/loader.dart';
import 'package:homecook/models/cart_item.dart';
import 'package:homecook/models/item.dart';
import 'package:homecook/providers/cart_provider.dart';
import 'package:homecook/utilities/globals.dart';
import 'package:provider/provider.dart';

class ItemScreen extends StatefulWidget {
  static const String routeName = '/item-screen';

  @override
  _ItemScreenState createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  CartItem _cartItem;

  bool processed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final Item item = ModalRoute.of(context).settings.arguments;
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final foundCartItem = cartProvider.getCartItem(item);
      setState(() {
        _cartItem = CartItem(
          item,
          foundCartItem != null ? foundCartItem.quantity : 0,
        );
        processed = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final Item item = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 25,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: processed ? buildBody(item) : Loader(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 10,
        ),
        child: Row(
          children: [
            IconButton(
              color: Colors.grey,
              icon: Icon(Icons.favorite),
              onPressed: () {},
            ),
            SizedBox(width: 10),
            Expanded(
              child: RaisedButton(
                child: Text(
                  'Update to cart',
                  textScaleFactor: 1.2,
                ),
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: 16),
                color: Theme.of(context).accentColor,
                textColor: Theme.of(context).colorScheme.onPrimary,
                onPressed: () {
                  cartProvider.updateCartItem(_cartItem);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
    );
  }

  Column buildBody(Item item) {
    return Column(
      children: [
        ClipPath(
          clipper: WaveClipperTwo(),
          child: Image.asset('assets/images/chef.jpg'),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  item.name,
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.remove,
                      color: Colors.blueGrey,
                    ),
                    onPressed: () {
                      setState(() {
                        if (_cartItem.quantity > 0) {
                          _cartItem.quantity -= 1;
                        }
                      });
                    },
                  ),
                  SizedBox(width: 10),
                  Text(
                    _cartItem.quantity.toString(),
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.blueGrey,
                    ),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    icon: Icon(
                      Icons.add,
                      color: Colors.blueGrey,
                    ),
                    onPressed: () {
                      setState(() {
                        if (_cartItem.quantity < item.quantity) {
                          _cartItem.quantity += 1;
                        }
                      });
                    },
                  ),
                  Spacer(),
                  Text(
                    inr + item.price.toString(),
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              Text(
                'Description',
                style: TextStyle(
                  fontFamily: 'Lato',
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 14),
              Text(
                item.description,
                style: TextStyle(
                  fontFamily: 'Lato',
                  color: Colors.black54,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
