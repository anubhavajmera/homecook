import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

void showFlushbarAlert(
    {BuildContext context,
    title,
    message,
    Color color,
    String actionText = '',
    Function press}) {
  Flushbar(
    backgroundColor: color,
    title: title.toString(),
    message: message.toString(),
    duration: Duration(seconds: 3),
    isDismissible: actionText != "",
    mainButton: actionText != ""
        ? FlatButton(
            onPressed: press,
            child: Text(actionText),
          )
        : Container(),
  )..show(context);
}
