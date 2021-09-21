import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';
import 'package:homecook/apis/users.dart';
import 'package:homecook/models/user.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homecook/utilities/globals.dart';

class UserProvider extends ChangeNotifier {
  User _currentUser = User();

  User get currentUser => _currentUser;

  set currentUser(User user) {
    _currentUser = user;
    loggedInUser = currentUser;
    notifyListeners();
  }

  bool get isAvailable => _currentUser.email != null;

  LatLng get location => LatLng(_currentUser.latitude, _currentUser.longitude);

  set location(LatLng coords) {
    _currentUser.latitude = coords.latitude;
    _currentUser.longitude = coords.longitude;
    notifyListeners();
  }

  String get address => _currentUser.address;

  set address(String address) {
    _currentUser.address = address;
    notifyListeners();
  }

  Future intializeUser() {
    final Completer _completer = Completer();
    final firebaseUser = auth.FirebaseAuth.instance.currentUser;
    print(firebaseUser);
    User tempUser = User(
      uid: firebaseUser.uid,
      name: firebaseUser.displayName,
      email: firebaseUser.email,
      phoneNumber: firebaseUser.phoneNumber,
      photoUrl: firebaseUser.photoURL,
      address: '',
      latitude: 0.0,
      longitude: 0.0,
      balance: 0,
    );

    UsersApi().fetchOrCreateUser(tempUser).then((user) {
      currentUser = user;
      _completer.complete(user);
    });
    return _completer.future;
  }
}
