import 'package:google_maps_flutter/google_maps_flutter.dart';

class User {
  int id;
  String uid;
  String name;
  String email;
  String phoneNumber;
  String photoUrl;
  String address;
  double latitude;
  double longitude;
  double balance;
  String deviceId;
  bool eligibleToSell;

  User({
    this.id,
    this.uid,
    this.name,
    this.email,
    this.phoneNumber,
    this.photoUrl,
    this.address,
    this.latitude,
    this.longitude,
    this.balance,
    this.deviceId,
    this.eligibleToSell
  });

  get location => LatLng(latitude, longitude);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      photoUrl: json['photo_url'],
      address: json['address'],
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']),
      balance: json['balance'],
      deviceId: json['device_id'],
      eligibleToSell: json['eligible_to_sell']
    );
  }
}
