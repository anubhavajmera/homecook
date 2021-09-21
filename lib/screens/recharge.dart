import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homecook/apis/recharges.dart';
import 'package:homecook/components/flushbar_alert.dart';
import 'package:homecook/components/loader.dart';
import 'package:homecook/models/recharge.dart';
import 'package:homecook/models/user.dart';
import 'package:homecook/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RechargeScreen extends StatefulWidget {
  static const String routeName = '/recharge-screen';

  @override
  _RechargeScreenState createState() => _RechargeScreenState();
}

class _RechargeScreenState extends State<RechargeScreen> {
  Razorpay _razorpay;
  bool processing = false;
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  User user;

  @override
  void initState() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    user = userProvider.currentUser;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    Recharge payment = Recharge(
      amount: double.parse(_amountController.text),
      paymentId: response.paymentId,
      orderId: response.orderId,
      signature: response.signature,
      method: "",
      uid: user.uid,
      status: "SUCCESS",
      createdAt: DateTime.now().toString(),
    );
    await RechargesApi().createRecharge(payment);
    showFlushbarAlert(
      context: context,
      title: "Payment Success",
      message: "SUCCESS: ",
      color: Colors.green,
      actionText: 'Okay',
      press: () => Navigator.of(context).pop(),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    showFlushbarAlert(
      context: context,
      title: "Payment Failed",
      message: "ERROR: " + response.message,
      color: Colors.red,
      actionText: 'Cancel',
      press: () => Navigator.of(context).pop(),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) async {
    Recharge payment = Recharge(
      paymentId: "",
      orderId: "",
      signature: "",
      method: response.walletName,
      amount: double.parse(_amountController.text),
      uid: user.uid,
      status: "SUCCESS",
      createdAt: DateTime.now().toString(),
    );
    await RechargesApi().createRecharge(payment);
    showFlushbarAlert(
      context: context,
      title: "External Wallet Used",
      message: "EXTERNAL WALLET: " + response.walletName,
      color: Colors.green,
      actionText: 'Okay',
      press: () => Navigator.of(context).pop(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Recharge Wallet',
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
      body: buildBody(context),
      bottomNavigationBar: !processing
          ? Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10,
              ),
              child: FlatButton(
                child: Text(
                  'Proceed to pay',
                  textScaleFactor: 1.2,
                ),
                padding: EdgeInsets.symmetric(vertical: 16),
                color: Theme.of(context).colorScheme.secondary,
                textColor: Theme.of(context).colorScheme.onSecondary,
                onPressed: () => _processRecharge(),
              ),
            )
          : Text(''),
    );
  }

  Widget buildBody(context) {
    return Column(
      children: <Widget>[
        Spacer(),
        Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                prefix: Text(
                  ' ₹ ',
                  textScaleFactor: 1.3,
                ),
                hintText: 'Enter Amount ( min ₹50 )',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value.trim().isEmpty) {
                  return 'Please enter some amount';
                }
                double amount = double.parse(value.trim());
                if (amount > 2000 || amount < 50) {
                  return 'Please enter in range of 50-2000';
                }
                return null;
              },
              onFieldSubmitted: (_) => _processRecharge(),
            ),
          ),
        ),
        if (processing) Loader(),
        Spacer(),
      ],
    );
  }

  void _processRecharge() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      var options = {
        'key': 'rzp_test_K4qqgkI6Wzh2KO',
        'amount': (int.parse(_amountController.text) * 100).toString(),
        'name': 'Qc4 Application',
        'currency': 'INR',
        'description': 'HomeCook Wallet',
        'prefill': {
          'contact': user.phoneNumber,
          'email': user.email,
        },
      };
      try {
        _razorpay.open(options);
      } catch (e) {
        debugPrint(e);
      }
    }
  }
}
