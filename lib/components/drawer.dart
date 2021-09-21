import 'package:flutter/material.dart';
import 'package:homecook/providers/user_provider.dart';
import 'package:homecook/screens/about.dart';
import 'package:homecook/screens/home.dart';
import 'package:homecook/screens/notification.dart';
import 'package:homecook/screens/placed_orders.dart';
import 'package:homecook/screens/profile.dart';
import 'package:homecook/screens/recieved_orders.dart';
import 'package:homecook/screens/wallet.dart';
import 'package:homecook/services/auth.dart';
import 'package:provider/provider.dart';

class DrawerItem {
  final String title;
  final IconData icon;
  final String target;
  DrawerItem(this.title, this.icon, this.target);
}

class DrawerMenu extends StatelessWidget {
  final context;
  DrawerMenu({Key key, this.context}) : super(key: key);

  static List _drawerItems = [
    DrawerItem("Home", Icons.home, HomeScreen.routeName),
    DrawerItem('Profile', Icons.person_outline, ProfileScreen.routeName),
    DrawerItem('Wallet', Icons.account_balance_wallet, WalletScreen.routeName),
    DrawerItem(
        "Placed Orders", Icons.cloud_upload, PlacedOrdersScreen.routeName),
    DrawerItem("Recieved Orders", Icons.cloud_download,
        RecievedOrdersScreen.routeName),
    DrawerItem("About", Icons.info_outline, AboutScreen.routeName),
    DrawerItem("Notifications", Icons.notifications_active,
        NotificationScreen.routeName),
  ];

  List<Widget> _buildDrawerItems() {
    List<Widget> options = [];
    for (var drawerItem in _drawerItems) {
      options.add(
        ListTile(
          leading: Icon(
            drawerItem.icon,
            color: Colors.blueGrey,
          ),
          title: Text(drawerItem.title),
          onTap: () {
            Navigator.popAndPushNamed(context, drawerItem.target);
          },
        ),
      );
    }

    options.add(
      ListTile(
        leading: const Icon(Icons.lock_open),
        title: const Text('Log out'),
        onTap: () {
          AuthService().signOut();
          Navigator.popUntil(context, ModalRoute.withName('/'));
        },
      ),
    );
    return options;
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserProvider>(context).currentUser;

    return Drawer(
      elevation: 32,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(currentUser.name),
              accountEmail: Text(currentUser.email),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(currentUser.photoUrl),
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage("assets/images/bg.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(children: _buildDrawerItems())
          ],
        ),
      ),
    );
  }
}
