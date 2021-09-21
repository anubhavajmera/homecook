import 'package:flutter/material.dart';
import 'package:homecook/apis/recharges.dart';
import 'package:homecook/components/loader.dart';
import 'package:homecook/models/recharge.dart';
import 'package:homecook/utilities/convertor.dart';
import 'package:homecook/utilities/globals.dart';

class RechargeHistoryScreen extends StatefulWidget {
  static const routeName = '/recharge-history';

  @override
  _RechargeHistoryScreenState createState() => _RechargeHistoryScreenState();
}

class _RechargeHistoryScreenState extends State<RechargeHistoryScreen> {
  bool processing = true;
  var rechargeList;
  @override
  void initState() {
    super.initState();
    RechargesApi().fetchRechargeHistory().then((recharges) {
      setState(() {
        rechargeList = recharges;
        processing = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Recharge History',
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
      body: processing ? Loader() : buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return ListView.builder(
      itemCount: rechargeList.length,
      itemBuilder: (context, index) {
        Recharge recharge = rechargeList[index];
        return ListTile(
          title: Text(
            inr + recharge.amount.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          subtitle: Text(formatTimestamp(recharge.createdAt)),
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).accentColor,
            foregroundColor: Colors.white,
            child: Icon(Icons.check),
          ),
          trailing: Text(recharge.method),
          onTap: () {},
        );
      },
    );
  }
}
