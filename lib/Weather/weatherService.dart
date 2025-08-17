import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:personal_application/Weather/weather_api_fetch.dart';

class Weatherservice {
  static const BASE_URL = "https://api.openweathermap.org/data/2.5/weather";
  final String apiKey;

  Weatherservice(this.apiKey);

  Future<WeatherApiFetch> getWeather(String location) async {
    String url;

    if (location.contains(",")) {
      final parts = location.split(",");
      final lat = parts[0];
      final lon = parts[1];
      url = '$BASE_URL?lat=$lat&lon=$lon&appid=$apiKey&units=metric';
    } else {
      url = '$BASE_URL?q=$location&appid=$apiKey&units=metric';
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return WeatherApiFetch.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data: ${response.body}');
    }
  }

  Future<String> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("❌ Location permission permanently denied.");
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return "${position.latitude},${position.longitude}";
  }
}
