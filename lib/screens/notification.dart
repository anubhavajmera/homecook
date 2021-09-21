import 'package:flutter/material.dart';
import 'package:homecook/components/drawer.dart';

class NotificationScreen extends StatelessWidget {
  static const routeName = '/notification-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: DrawerMenu(
        context: context,
      ),
      body: Center(),
    );
  }
}
