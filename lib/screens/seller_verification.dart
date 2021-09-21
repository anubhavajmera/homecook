import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SellerVerification extends StatefulWidget {
  static String routeName = '/seller_verification';
  @override
  _SellerVerificationState createState() => _SellerVerificationState();
}

class _SellerVerificationState extends State<SellerVerification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Center(
              child: Text("For selling food, You need to mail your food selling licence for verification to admin@qc4application.com", style: TextStyle(fontSize: 15),),
              ),
              Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10,
              ),
              child: FlatButton(
                child: Text(
                  'Register Your Shop',
                  textScaleFactor: 1.2,
                ),
                padding: EdgeInsets.symmetric(vertical: 16),
                color: Theme.of(context).colorScheme.secondary,
                textColor: Theme.of(context).colorScheme.onSecondary,
                onPressed: () async{
                  final Uri params = Uri(
                    scheme: 'mailto',
                    path: 'email@example.com',
                    query: 'subject=Register My Shop', //add subject and body here
                  );
                  var url = params.toString();
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10,
              ),
              child: FlatButton(
                child: Text(
                  'Mail Us Your Licence',
                  textScaleFactor: 1.2,
                ),
                padding: EdgeInsets.symmetric(vertical: 16),
                color: Theme.of(context).colorScheme.secondary,
                textColor: Theme.of(context).colorScheme.onSecondary,
                onPressed: () async{
                  var url = "https://foodlicensing.fssai.gov.in/fees_structure.html#about-tab";
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}