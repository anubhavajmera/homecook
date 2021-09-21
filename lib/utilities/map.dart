import 'package:geolocator/geolocator.dart';
import 'package:map_launcher/map_launcher.dart';

void launchMap(coords, title, description) async {
  if (await MapLauncher.isMapAvailable(MapType.google)) {
    await MapLauncher.showMarker(
      mapType: MapType.google,
      coords: Coords(coords.latitude, coords.longitude),
      title: title,
      description: description,
    );
  }
}

// Future<String> getAddressFromLatLng(_currentPosition) async {
//   final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
//
//   List<Placemark> p = await geolocator.placemarkFromCoordinates(
//       _currentPosition.latitude, _currentPosition.longitude);
//
//   Placemark place = p[0];
//
//   return "${place.subLocality}, ${place.locality}";
// }
