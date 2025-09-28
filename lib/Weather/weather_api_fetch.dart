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
    final windSpeed = json['wind']?['speed'] ?? 0;
    final windMs = (windSpeed is int)
        ? windSpeed.toDouble()
        : windSpeed.toDouble();
    final windKmh = windMs * 3.6;

    int chanceOfRain = 0;

    if (json['rain'] != null) {
      chanceOfRain = 100;
    }

    final temp = json['main']['temp'];
    final temperature = (temp is int) ? temp.toDouble() : temp.toDouble();

    final humidity = json['main']['humidity'];
    final humidityValue = (humidity is int)
        ? humidity.toDouble()
        : humidity.toDouble();

    return WeatherApiFetch(
      locationName: json['name'],
      temperature: temperature,
      Wind: windKmh,
      Humidity: humidityValue,
      chance_of_rain: chanceOfRain,
      mainCondition: json['weather'][0]['main'],
    );
  }
}
