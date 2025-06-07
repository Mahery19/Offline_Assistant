import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  static Future<String> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return 'Location services are disabled. Please enable GPS.';
    }

    // Check for permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return 'Location permission denied.';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return 'Location permissions are permanently denied.';
    }

    // Get position
    final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    // Try to get placemark info (city, country)
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        final city = placemark.locality ?? '';
        final country = placemark.country ?? '';
        return 'You are at $city, $country. (Latitude: ${position.latitude.toStringAsFixed(3)}, Longitude: ${position.longitude.toStringAsFixed(3)})';
      }
    } catch (e) {
      // If reverse geocoding fails, just give coordinates
    }
    return 'Your location: Latitude ${position.latitude}, Longitude ${position.longitude}';
  }
}
