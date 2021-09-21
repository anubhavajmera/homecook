import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homecook/apis/users.dart';
import 'package:homecook/components/flushbar_alert.dart';
import 'package:homecook/models/user.dart';
import 'package:homecook/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile-screen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  User _user = User();

  @override
  void initState() {
    _user = Provider.of<UserProvider>(context, listen: false).currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
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
            );
          },
        ),
        title: Text(
          'My Profile',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontFamily: 'Lato',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: buildBody(context),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 32.0,
          vertical: 10,
        ),
        child: RaisedButton(
          child: Text(
            'Update Profile',
            textScaleFactor: 1.2,
          ),
          elevation: 0,
          padding: EdgeInsets.symmetric(vertical: 16),
          color: Theme.of(context).accentColor,
          textColor: Theme.of(context).colorScheme.onPrimary,
          onPressed: () {
            _updateProfile(context);
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
    );
  }

  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(height: 150),
          CircleAvatar(
            backgroundImage: NetworkImage(
              _user.photoUrl,
            ),
            radius: 75,
          ),
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    initialValue: _user.name,
                    decoration: InputDecoration(labelText: 'Name'),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return 'Please enter your name.';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) {},
                    onSaved: (value) {
                      _user.name = value.trim();
                    },
                  ),
                  TextFormField(
                    initialValue: _user.phoneNumber,
                    decoration: InputDecoration(labelText: 'Phone Number'),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return 'Please enter your phone number.';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) {},
                    onSaved: (value) {
                      _user.phoneNumber = value.trim();
                    },
                  ),
                  TextFormField(
                    initialValue: _user.address,
                    maxLines: 3,
                    decoration: InputDecoration(labelText: 'Address'),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return 'Please enter your address.';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) {},
                    onSaved: (value) {
                      _user.address = value.trim();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateProfile(context) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      UsersApi().updateUser(_user).then((_) {
        showFlushbarAlert(
          context: context,
          title: 'Yohooo',
          message: 'Profile updated !!',
          color: Colors.green,
        );
      }).whenComplete(() {
        userProvider.intializeUser();
        Navigator.popUntil(context, ModalRoute.withName('/'));
      });
    }
  }
}
