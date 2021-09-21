import 'dart:async';

import 'package:access_settings_menu/access_settings_menu.dart';
import 'package:extension/string.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homecook/apis/users.dart';
import 'package:homecook/components/drawer.dart';
import 'package:homecook/components/flushbar_alert.dart';
import 'package:homecook/utilities/globals.dart' as globals;
import 'package:homecook/components/loader.dart';
import 'package:homecook/providers/user_provider.dart';
import 'package:homecook/screens/items.dart';
import 'package:homecook/screens/sell.dart';
import 'package:homecook/utilities/map.dart';
import 'package:location/location.dart' as loc;
import 'package:provider/provider.dart';

import 'seller_verification.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Set<Marker> _markers = {};
  TextEditingController _addressController;
  final Geolocator geolocator = Geolocator();
  Completer<GoogleMapController> _controller = Completer();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    _fcm.getToken().then((token) {
      globals.deviceId = token;
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.intializeUser().then((user) {
        userProvider.currentUser = user;
        if (userProvider.currentUser.deviceId != globals.deviceId) {
          UsersApi().updateDeviceId(user, globals.deviceId).then((user) {
            userProvider.currentUser = user;
          }).catchError((e) {
            showFlushbarAlert(
                color: Colors.red,
                context: context,
                message: e.toString(),
                title: "Error :");
          });
        }
        _getDefaultLocation(userProvider);
        _addressController = TextEditingController(text: userProvider.address);
      });
    });

    // _fcm.configure(
    //   onResume: (message) async {
    //     Navigator.of(context).pushNamed(message['data']['routeName']);
    //   },
    // );
  }

  loc.Location location = loc.Location();
  Future _checkGps() async {
    bool isGPSEnabled = await location.serviceEnabled();
    if (!isGPSEnabled) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Turn On GPS :"),
            content: Text(
                "You are being redirected to location Settings page. For the better experience you have to choose High Accuracy mode."),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel"),
              ),
              FlatButton(
                onPressed: () async {
                  await AccessSettingsMenu.openSettings(
                      settingsType: 'ACTION_LOCATION_SOURCE_SETTINGS');
                  Navigator.pop(context);
                },
                child: Text("OK"),
              )
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    globals.screenHeight = MediaQuery.of(context).size.height;
    globals.screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                size: 28,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: buildBody(context),
      drawer: DrawerMenu(
        context: context,
      ),
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
    );
  }

  Widget buildBody(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    if (userProvider.isAvailable) {
      return Column(
        children: <Widget>[
          Container(
            height: globals.screenHeight * 0.85,
            child: GoogleMap(
              markers: _markers,
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: userProvider.location,
                zoom: 14.5,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
          Container(
            height: globals.screenHeight * 0.15,
            padding: const EdgeInsets.symmetric(
              horizontal: 18.0,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    padding: const EdgeInsets.all(0),
                    textTheme: ButtonTextTheme.primary,
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.edit_location),
                        Text(
                          userProvider.address,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textScaleFactor: 1.2,
                        ),
                      ],
                    ),
                    onPressed: () {
                      _addressController.text = userProvider.address;
                      _buildShowAddressDialog(context);
                    },
                  ),
                  Row(
                    children: <Widget>[
                      FlatButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, ItemsScreen.routeName),
                        color: Theme.of(context).colorScheme.secondaryVariant,
                        child: const Text(
                          'Order',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      FlatButton(
                        onPressed: () {
                          if (userProvider.currentUser.eligibleToSell == true) {
                            Navigator.pushNamed(context, SellScreen.routeName);
                          } else {
                            Navigator.pushNamed(
                                context, SellerVerification.routeName);
                          }
                        },
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        child: const Text(
                          'Sell',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    Theme.of(context).accentColor.withAlpha(20),
                                blurRadius: 4.0,
                                spreadRadius: 4.0,
                              ),
                            ]),
                        child: IconButton(
                          color: Theme.of(context).primaryColor,
                          icon: Icon(Icons.location_searching),
                          onPressed: () {
                            // _getCurrentLocation(userProvider);
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      );
    } else {
      return Center(
        child: Loader(
          msg: 'Provisioning user resources',
        ),
      );
    }
  }

  Future _buildShowAddressDialog(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext cntxt) {
        return AlertDialog(
          title: Text('Edit Address'),
          content: TextField(
            controller: _addressController,
          ),
          actions: <Widget>[
            FlatButton(
              textColor: Colors.blue,
              splashColor: Colors.blueAccent,
              child: Text('Update'),
              onPressed: () {
                userProvider.address = _addressController.text;
                _updateLocationToDb(userProvider);
                Navigator.of(cntxt).pop();
              },
            ),
            FlatButton(
              textColor: Colors.red,
              splashColor: Colors.redAccent,
              child: Text('Close'),
              onPressed: () {
                Navigator.of(cntxt).pop();
              },
            )
          ],
        );
      },
    );
  }

  void _getDefaultLocation(UserProvider userProvider) {
    if ((userProvider.location.latitude != 0.0 &&
            userProvider.location.longitude != 0.0) ||
        userProvider.address != '') {
      _updateMarker(userProvider);
    } else {
      _getCurrentLocation(userProvider);
    }
  }

  void _getCurrentLocation(UserProvider userProvider) {
    _checkGps();
    // geolocator
    //     .getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation)
    //     .then((Position position) {
    //   userProvider.currentUser.latitude = position.latitude;
    //   userProvider.currentUser.longitude = position.longitude;
    //   _updateMarker(userProvider);
    //   // getAddressFromLatLng(userProvider.currentUser.location).then((value) {
    //     userProvider.address = value.capitalizeFirstLetter();
    //   }).whenComplete(() => _updateLocationToDb(userProvider));
    //   _repositionCamera(userProvider);
    // }).catchError((e) {
    //   print(e);
    // });
  }

  Future<void> _repositionCamera(UserProvider userProvider) async {
    CameraPosition cameraPosition = CameraPosition(
      target: userProvider.location,
      zoom: 14.5,
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  void _updateLocationToDb(userProvider) {
    UsersApi()
        .updateUser(userProvider.currentUser)
        .then((value) {})
        .catchError((e) {
      print(e);
    });
  }

  void _updateMarker(userProvider) {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId(userProvider.currentUser.location.toString()),
          position: LatLng(userProvider.currentUser.location.latitude,
              userProvider.currentUser.location.longitude),
          infoWindow: InfoWindow(
            title: 'You are here !',
            snippet: userProvider.address,
          ),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    });
  }
}
