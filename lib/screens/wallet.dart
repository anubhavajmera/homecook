import 'package:flutter/material.dart';
import 'package:homecook/components/drawer.dart';
import 'package:homecook/providers/user_provider.dart';
import 'package:homecook/screens/recharge.dart';
import 'package:homecook/screens/recharge_history.dart';
import 'package:provider/provider.dart';

class WalletScreen extends StatefulWidget {
  static const routeName = '/wallet-screen';

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.intializeUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'My Wallet',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontFamily: 'Lato',
            fontWeight: FontWeight.bold,
          ),
        ),
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
      ),
      drawer: DrawerMenu(
        context: context,
      ),
      body: buildBody(context),
    );
  }

  Widget buildBody(context) {
    return Column(
      children: <Widget>[
        Spacer(),
        Center(
          child: Consumer<UserProvider>(
            builder: (context, value, child) => Text(
              '₹ ' + value.currentUser.balance.toString(),
              textScaleFactor: 3.5,
              style: TextStyle(
                color: Colors.blueGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        Spacer(),
        RaisedButton(
          color: Theme.of(context).colorScheme.secondary,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.add_circle_outline),
                Text(
                  '  Recharge Wallet  ',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          onPressed: () {
            Navigator.pushNamed(context, RechargeScreen.routeName);
          },
        ),
        SizedBox(
          height: 8.0,
        ),
        RaisedButton(
          color: Theme.of(context).accentColor,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.history),
                Text(
                  '  Recharge History',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          onPressed: () {
            Navigator.pushNamed(context, RechargeHistoryScreen.routeName);
          },
        ),
        Spacer(),
      ],
    );
  }
}
