import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class WeatherService {
  static const String _apiKey = '6d9f091cf28d5012e79c17acc0266b4d'; // <-- Replace with your key

  static Future<String> getCurrentWeather() async {
    try {
      // Get current location
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
      final lat = position.latitude;
      final lon = position.longitude;

      // API request
      final url =
          'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$_apiKey&units=metric';

      final response = await http.get(Uri.parse(url));
      print('Weather API Response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final description = data['weather'][0]['description'];
        final temp = data['main']['temp'].round();
        final city = data['name'];
        return 'The weather in $city is $description with a temperature of $temp degrees Celsius.';
      } else {
        return 'Could not fetch weather info.';
      }
    } catch (e) {
      return 'Unable to get weather: $e';
    }
  }
}
