import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loader extends StatelessWidget {
  final msg;

  Loader({this.msg = ''});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SpinKitThreeBounce(
          color: Theme.of(context).primaryColor,
          size: 50.0,
        ),
        Text(
          msg.toString(),
          style: Theme.of(context).textTheme.subtitle1.apply(
                color: Theme.of(context).primaryColor,
              ),
        ),
      ],
    );
  }
}
