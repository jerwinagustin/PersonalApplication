class WeatherApiFetch {
  final String locationName;
  final double temperature;
  final double Wind;
  final double Humidity;
  final int chance_of_rain;
  final String mainCondition;

  WeatherApiFetch({
    required this.locationName,
    required this.temperature,
    required this.Wind,
    required this.Humidity,
    required this.chance_of_rain,
    required this.mainCondition,
  });

  factory WeatherApiFetch.fromJson(Map<String, dynamic> json) {
    final windMs = (json['wind']?['speed'] ?? 0).toDouble();
    final windKmh = windMs * 3.6;

    int chanceOfRain = 0;

    if (json['rain'] != null) {
      chanceOfRain = 100;
    }
    return WeatherApiFetch(
      locationName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      Wind: windKmh,
      Humidity: json['main']['humidity'].toInt(),
      chance_of_rain: chanceOfRain,
      mainCondition: json['weather'][0]['main'],
    );
  }
}
