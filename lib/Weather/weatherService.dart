import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:personal_application/Weather/weather_api_fetch.dart';

class Weatherservice {
  static const BASE_URL = "https://api.openweathermap.org/data/2.5/weather";
  static const FORECAST_URL =
      "https://api.openweathermap.org/data/2.5/forecast";
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

  // New method to get 7-day forecast
  Future<List<ForecastDay>> get7DayForecast(String location) async {
    String url;

    if (location.contains(",")) {
      final parts = location.split(",");
      final lat = parts[0];
      final lon = parts[1];
      url = '$FORECAST_URL?lat=$lat&lon=$lon&appid=$apiKey&units=metric';
    } else {
      url = '$FORECAST_URL?q=$location&appid=$apiKey&units=metric';
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return _processForecastData(data);
    } else {
      throw Exception('Failed to load forecast data: ${response.body}');
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
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("⚠ Location permission permanently denied.");
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return "${position.latitude},${position.longitude}";
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
