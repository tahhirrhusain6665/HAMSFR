import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> currentPosition() async {
    var enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) throw Exception('Location service is disabled.');

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception('Location permission is required.');
    }
    return Geolocator.getCurrentPosition();
  }

  Stream<Position> watchPosition() =>
      Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      );
}
