import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:homecook/components/filter_bottom_sheet.dart';
import 'package:homecook/components/loader.dart';
import 'package:homecook/models/item.dart';
import 'package:homecook/providers/cart_provider.dart';
import 'package:homecook/providers/items_provider.dart';
import 'package:homecook/providers/user_provider.dart';
import 'package:homecook/screens/cart_details.dart';
import 'package:homecook/screens/item_details.dart';
import 'package:homecook/utilities/globals.dart';
import 'package:provider/provider.dart';

class ItemsScreen extends StatefulWidget {
  static const String routeName = '/items-screen';

  @override
  _ItemsScreenState createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final _itemsProvider = Provider.of<ItemsProvider>(context, listen: false);
      _itemsProvider.initializeItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser =
        Provider.of<UserProvider>(context, listen: false).currentUser;

    final _itemsProvider = Provider.of<ItemsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, ${currentUser.name.split(' ')[0]} !',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w400,
                fontFamily: 'Lato',
                fontSize: 14,
              ),
            ),
            Text(
              'Choose your food today',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Lato',
              ),
            ),
          ],
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 24,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.sort),
            color: Colors.blueGrey,
            onPressed: () => _showFiltersBottomSheet(context),
          ),
          Consumer<CartProvider>(
            builder: (context, value, child) {
              if (value.cartItems.length > 0) {
                return IconButton(
                  padding: const EdgeInsets.only(right: 16),
                  icon: Badge(
                    badgeColor: Theme.of(context).colorScheme.secondary,
                    badgeContent: Consumer<CartProvider>(
                      builder: (context, value, child) =>
                          Text(value.cartItems.length.toString()),
                    ),
                    child: Icon(Icons.shopping_cart),
                  ),
                  color: Colors.blueGrey,
                  onPressed: () {
                    Navigator.pushNamed(context, CartScreen.routeName);
                  },
                );
              } else {
                return Text('');
              }
            },
          ),
        ],
      ),
      body: _itemsProvider.items != [] ? buildBody(context) : Loader(),
    );
  }

  Widget buildBody(BuildContext context) {
    ItemsProvider _itemsProvider =
        Provider.of<ItemsProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          Image.asset('assets/images/chef_white.jpg'),
          ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: _itemsProvider.filteredItems.length,
            itemBuilder: (BuildContext context, index) {
              Item item = _itemsProvider.filteredItems[index];
              return InkWell(
                child: Card(
                  margin: EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                  color: Colors.grey.shade200,
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                        child: Image.asset(
                          'assets/images/chef.jpg',
                          height: 100,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Badge(
                            padding: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            elevation: 0,
                            badgeColor: Theme.of(context).accentColor,
                            toAnimate: false,
                            // borderRadius: 4,
                            badgeContent: Text(
                              inr + item.price.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            shape: BadgeShape.square,
                          ),
                          SizedBox(height: 16),
                          Text(
                            item.name,
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "${item.user.name} ( ${item.getDistanceFromUser().toStringAsFixed(1)} km )",
                            style: TextStyle(
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    ItemScreen.routeName,
                    arguments: item,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void _showFiltersBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext cntxt) {
        return FilterBottomSheet();
      },
    );
  }
}
