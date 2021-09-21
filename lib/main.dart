import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:homecook/providers/cart_provider.dart';
import 'package:homecook/providers/items_provider.dart';
import 'package:homecook/providers/user_provider.dart';
import 'package:homecook/screens/about.dart';
import 'package:homecook/screens/cart_details.dart';
import 'package:homecook/screens/home.dart';
import 'package:homecook/screens/intro.dart';
import 'package:homecook/screens/item_details.dart';
import 'package:homecook/screens/login.dart';
import 'package:homecook/screens/notification.dart';
import 'package:homecook/screens/items.dart';
import 'package:homecook/screens/placed_orders.dart';
import 'package:homecook/screens/profile.dart';
import 'package:homecook/screens/recharge.dart';
import 'package:homecook/screens/recharge_history.dart';
import 'package:homecook/screens/recieved_orders.dart';
import 'package:homecook/screens/sell.dart';
import 'package:homecook/screens/seller_verification.dart';
import 'package:homecook/screens/splash.dart';
import 'package:homecook/screens/wallet.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ItemsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'HomeCook',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light().copyWith(
          primaryColor: Colors.teal,
          colorScheme: ColorScheme(
            primary: Colors.teal,
            primaryVariant: Colors.tealAccent,
            secondary: Colors.amber,
            secondaryVariant: Colors.amberAccent,
            surface: Colors.white,
            background: Colors.white,
            error: Colors.red,
            onPrimary: Colors.white,
            onSecondary: Colors.black87,
            onSurface: Colors.blueGrey,
            onBackground: Colors.blueGrey,
            onError: Colors.white,
            brightness: Brightness.light,
          ),
          accentColor: Colors.cyan,
          buttonTheme: ButtonThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return SellerVerification();
            } else {
              return SellerVerification();
            }
          },
        ),
        routes: {
          AboutScreen.routeName: (_) => AboutScreen(),
          CartScreen.routeName: (_) => CartScreen(),
          HomeScreen.routeName: (_) => HomeScreen(),
          IntroScreen.routeName: (_) => IntroScreen(),
          ItemScreen.routeName: (_) => ItemScreen(),
          ItemsScreen.routeName: (_) => ItemsScreen(),
          LoginScreen.routeName: (_) => LoginScreen(),
          NotificationScreen.routeName: (_) => NotificationScreen(),
          PlacedOrdersScreen.routeName: (_) => PlacedOrdersScreen(),
          ProfileScreen.routeName: (_) => ProfileScreen(),
          RechargeScreen.routeName: (_) => RechargeScreen(),
          RecievedOrdersScreen.routeName: (_) => RecievedOrdersScreen(),
          RechargeHistoryScreen.routeName: (_) => RechargeHistoryScreen(),
          SellScreen.routeName: (_) => SellScreen(),
          SplashScreen.routeName: (_) => SplashScreen(),
          WalletScreen.routeName: (_) => WalletScreen(),
          SellerVerification.routeName: (_) => SellerVerification()
        },
      ),
    );
  }
}
