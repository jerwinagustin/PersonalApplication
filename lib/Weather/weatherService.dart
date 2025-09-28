import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:personal_application/Weather/weather_api_fetch.dart';

class Weatherservice {
  static const BASE_URL = "https://api.openweathermap.org/data/2.5/weather";
  static const FORECAST_URL =
      "https://api.openweathermap.org/data/2.5/forecast";
  final String apiKey;

  Weatherservice(this.apiKey);

  Future<WeatherApiFetch> getWeather(String location) async {
    try {
      String url;

      if (location.contains(",")) {
        final parts = location.split(",");
        final lat = parts[0];
        final lon = parts[1];
        url = '$BASE_URL?lat=$lat&lon=$lon&appid=$apiKey&units=metric';
      } else {
        url = '$BASE_URL?q=$location&appid=$apiKey&units=metric';
      }

      print('Weather API URL: $url'); // Debug print

      // For web, we need to handle CORS differently
      if (kIsWeb) {
        print('Running on web - using CORS proxy or alternative approach');
        // For web testing, we can create mock data or use a CORS proxy
        // This is a temporary solution for web development
        return await _createMockWeatherData(location);
      }

      final response = await http
          .get(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              'User-Agent': 'PersonalApplication/1.0',
            },
          )
          .timeout(Duration(seconds: 15));

      print(
        'Weather API Response Status: ${response.statusCode}',
      ); // Debug print
      print('Weather API Response Body: ${response.body}'); // Debug print

      if (response.statusCode == 200) {
        return WeatherApiFetch.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          'Failed to load weather data: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Weather API Error: $e'); // Debug print
      rethrow;
    }
  }

  // New method to get 7-day forecast
  Future<List<ForecastDay>> get7DayForecast(String location) async {
    try {
      String url;

      if (location.contains(",")) {
        final parts = location.split(",");
        final lat = parts[0];
        final lon = parts[1];
        url = '$FORECAST_URL?lat=$lat&lon=$lon&appid=$apiKey&units=metric';
      } else {
        url = '$FORECAST_URL?q=$location&appid=$apiKey&units=metric';
      }

      print('Forecast API URL: $url'); // Debug print

      // For web, we need to handle CORS differently
      if (kIsWeb) {
        print('Running on web - using mock forecast data');
        return _createMockForecastData();
      }

      final response = await http
          .get(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              'User-Agent': 'PersonalApplication/1.0',
            },
          )
          .timeout(Duration(seconds: 15));

      print(
        'Forecast API Response Status: ${response.statusCode}',
      ); // Debug print

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return _processForecastData(data);
      } else {
        throw Exception(
          'Failed to load forecast data: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Forecast API Error: $e'); // Debug print
      rethrow;
    }
  }

  List<ForecastDay> _processForecastData(Map<String, dynamic> data) {
    final List<dynamic> forecastList = data['list'];
    final Map<String, List<dynamic>> dailyData = {};

    for (var forecast in forecastList) {
      final DateTime date = DateTime.fromMillisecondsSinceEpoch(
        forecast['dt'] * 1000,
      );
      final String dayKey =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

      if (!dailyData.containsKey(dayKey)) {
        dailyData[dayKey] = [];
      }
      dailyData[dayKey]!.add(forecast);
    }

    final List<ForecastDay> forecastDays = [];
    final sortedKeys = dailyData.keys.toList()..sort();

    for (int i = 0; i < sortedKeys.length && i < 7; i++) {
      final dayForecasts = dailyData[sortedKeys[i]]!;
      forecastDays.add(ForecastDay.fromDailyData(dayForecasts));
    }

    return forecastDays;
  }

  Future<String> getCurrentLocation() async {
    try {
      print('Checking location permissions...'); // Debug print

      LocationPermission permission = await Geolocator.checkPermission();
      print('Current permission status: $permission'); // Debug print

      if (permission == LocationPermission.denied) {
        print('Requesting location permission...'); // Debug print
        permission = await Geolocator.requestPermission();
        print('Permission after request: $permission'); // Debug print
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception("⚠ Location permission permanently denied.");
      }

      if (permission == LocationPermission.denied) {
        throw Exception("⚠ Location permission denied.");
      }

      print('Getting current position...'); // Debug print
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      );

      print(
        'Position obtained: ${position.latitude}, ${position.longitude}',
      ); // Debug print
      return "${position.latitude},${position.longitude}";
    } catch (e) {
      print('Error getting location: $e');
      rethrow;
    }
  }

  // Mock data for web development (CORS workaround)
  Future<WeatherApiFetch> _createMockWeatherData(String location) async {
    print('Creating mock weather data for web development');
    print('Location parameter: $location'); // Debug print

    String locationName = 'Current Location';

    // Check if coordinates match Capas, Tarlac area
    if (location.contains(",")) {
      try {
        final parts = location.split(",");
        final lat = double.parse(parts[0]);
        final lon = double.parse(parts[1]);

        print('Parsed coordinates: lat=$lat, lon=$lon'); // Debug print

        // Check if coordinates are in Capas, Tarlac area (approximate range)
        if (lat >= 15.32 && lat <= 15.33 && lon >= 120.58 && lon <= 120.59) {
          locationName = 'Capas, Tarlac';
          print('Coordinates match Capas, Tarlac area'); // Debug print
        } else {
          print(
            'Coordinates outside Capas range, trying geocoding...',
          ); // Debug print
          // Try geocoding for other locations
          try {
            List<Placemark> placemarks = await placemarkFromCoordinates(
              lat,
              lon,
            );
            if (placemarks.isNotEmpty) {
              final placemark = placemarks.first;
              locationName =
                  '${placemark.locality ?? placemark.subAdministrativeArea ?? placemark.administrativeArea ?? 'Unknown City'}';
              if (placemark.administrativeArea != null &&
                  placemark.administrativeArea != placemark.locality) {
                locationName += ', ${placemark.administrativeArea}';
              }
              print('Geocoding result: $locationName'); // Debug print
            }
          } catch (e) {
            print('Error getting location name from geocoding: $e');
            locationName = 'Current Location';
          }
        }
      } catch (e) {
        print('Error parsing coordinates: $e');
        locationName = 'Current Location';
      }
    }

    print('Final location name: $locationName'); // Debug print

    return WeatherApiFetch(
      locationName: locationName,
      temperature: 28.5,
      Wind: 15.3,
      Humidity: 75,
      chance_of_rain: 30,
      mainCondition: 'Clear',
    );
  }

  // Mock forecast for web development
  List<ForecastDay> _createMockForecastData() {
    print('Creating mock forecast data for web development');
    final today = DateTime.now();
    return List.generate(7, (index) {
      return ForecastDay(
        condition: index % 3 == 0
            ? 'clear'
            : index % 3 == 1
            ? 'clouds'
            : 'rain',
        highTemp: 30.0 + (index * 0.5),
        lowTemp: 22.0 + (index * 0.3),
        date: today.add(Duration(days: index)),
      );
    });
  }
}

class ForecastDay {
  final String condition;
  final double highTemp;
  final double lowTemp;
  final DateTime date;

  ForecastDay({
    required this.condition,
    required this.highTemp,
    required this.lowTemp,
    required this.date,
  });

  factory ForecastDay.fromDailyData(List<dynamic> dayForecasts) {
    double minTemp = double.infinity;
    double maxTemp = double.negativeInfinity;
    String mostCommonCondition = '';
    Map<String, int> conditionCounts = {};

    for (var forecast in dayForecasts) {
      final temp = forecast['main']['temp'].toDouble();
      minTemp = minTemp > temp ? temp : minTemp;
      maxTemp = maxTemp < temp ? temp : maxTemp;

      final condition = forecast['weather'][0]['main'].toString().toLowerCase();
      conditionCounts[condition] = (conditionCounts[condition] ?? 0) + 1;
    }

    mostCommonCondition = conditionCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    return ForecastDay(
      condition: mostCommonCondition,
      highTemp: maxTemp,
      lowTemp: minTemp,
      date: DateTime.fromMillisecondsSinceEpoch(
        dayForecasts.first['dt'] * 1000,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'condition': condition,
      'high': highTemp.round(),
      'low': lowTemp.round(),
    };
  }
}
