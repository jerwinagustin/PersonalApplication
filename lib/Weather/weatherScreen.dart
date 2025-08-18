import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:personal_application/Weather/weatherService.dart';
import 'package:personal_application/Weather/weather_api_fetch.dart';

class Weatherscreen extends StatefulWidget {
  const Weatherscreen({super.key});

  @override
  State<Weatherscreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Weatherscreen> {
  final _weatherService = Weatherservice('390bc03421b02c3b567a5d52acc9ddf3');
  WeatherApiFetch? _weather;
  List<ForecastDay>? _forecast;

  _fetchWeather() async {
    try {
      String locationName = await _weatherService.getCurrentLocation();
      print('Location: $locationName'); // Debug print

      final weather = await _weatherService.getWeather(locationName);
      print(
        'Weather data: ${weather.locationName}, ${weather.temperature}°C',
      ); // Debug print

      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print('Error fetching weather: $e');
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/weather_image/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
        return 'weather_image/Weather-windy.json';
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'weather_image/Cloudy.json';
      case 'rain':
        return 'weather_image/Rainy.json';
      case 'drizzle':
      case 'shower rain':
        return 'weather_image/Rainy_Sunny.json';
      case 'thunderstorm':
        return 'weather_image/Weather-thunder.json';
      case 'clear':
        return 'weather_image/sunny.json';
      default:
        return 'weather_image/sunny.json';
    }
  }

  _fetch7DayForecast() async {
    try {
      String locationName = await _weatherService.getCurrentLocation();
      final forecast = await _weatherService.get7DayForecast(locationName);
      print('Forecast data: ${forecast.length} days'); // Debug print

      setState(() {
        _forecast = forecast;
      });
    } catch (e) {
      print('Error fetching forecast: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
    _fetch7DayForecast();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final Format = DateFormat('EE, MMM d').format(now);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFF06011D),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 41,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0XFF9900FF),
                            Color(0xFF413243),
                            Color(0xFFFF00AA),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(36),
                      ),
                      padding: EdgeInsets.all(2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(36),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 493,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFF03000F),
                                Color(0xFF050017),
                                Color(0xFF170B3F),
                              ],
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 21,
                              vertical: 14,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                  child: Text(
                                    _weather?.locationName ??
                                        "Loading location...",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Inter',
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),

                                Lottie.asset(
                                  getWeatherAnimation(_weather?.mainCondition),
                                  height: 200,
                                ),

                                Text(
                                  _weather != null
                                      ? '${_weather!.temperature.round()}°C'
                                      : "Loading...",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    color: Colors.white,
                                    fontSize: 45,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),

                                Text(
                                  _weather?.mainCondition ?? "",
                                  style: TextStyle(
                                    fontSize: 21,
                                    fontFamily: 'Inter',
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  Format,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xFFBDBDBD),
                                    fontSize: 10,
                                  ),
                                ),

                                SizedBox(height: 21),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          SizedBox(width: 50),
                                          Icon(
                                            Icons.av_timer,
                                            size: 30,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            _weather != null
                                                ? '${_weather!.Wind.round()} km/h'
                                                : 'Loading...',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Inter',
                                              fontSize: 11,
                                            ),
                                          ),
                                          Text(
                                            'Wind',
                                            style: TextStyle(
                                              color: Color(0xFFBDBDBD),
                                              fontFamily: 'Inter',
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 60,
                                      width: 1,
                                      color: Color(0xFF2F187D),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Icon(
                                            Symbols.humidity_high,
                                            size: 30,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            _weather != null
                                                ? '${_weather!.Humidity.round()}%'
                                                : 'Loading...',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Inter',
                                              fontSize: 11,
                                            ),
                                          ),
                                          Text(
                                            'Humidity',
                                            style: TextStyle(
                                              color: Color(0xFFBDBDBD),
                                              fontFamily: 'Inter',
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 60,
                                      width: 1,
                                      color: Color(0xFF2F187D),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Icon(
                                            Symbols.water_drop,
                                            size: 30,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            _weather != null
                                                ? '${_weather!.chance_of_rain}%'
                                                : 'Loading...',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Inter',
                                              fontSize: 11,
                                            ),
                                          ),
                                          Text(
                                            'Chance of rain',
                                            style: TextStyle(
                                              color: Color(0xFFBDBDBD),
                                              fontFamily: 'Inter',
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    Row(
                      children: [
                        Text(
                          'Today',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Inter',
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Spacer(),
                        Text(
                          '7 days',
                          style: TextStyle(
                            color: Color(0xFFBDBDBD),
                            fontFamily: 'Inter',
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF9900FF),
                            Color(0xFF413243),
                            Color(0xFFFF00AA),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(36),
                      ),
                      padding: EdgeInsets.all(2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(36),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 123,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFF03000F),
                                Color(0xFF050017),
                                Color(0xFF170B3F),
                              ],
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 34,
                              vertical: 18,
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: List.generate(7, (index) {
                                  final day = DateFormat('EEE').format(
                                    DateTime.now().add(Duration(days: index)),
                                  );

                                  final dayData =
                                      _forecast != null &&
                                          _forecast!.length > index
                                      ? _forecast![index].toMap()
                                      : null;

                                  return Padding(
                                    padding: EdgeInsets.only(right: 33),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          day,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Inter',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        dayData != null
                                            ? Lottie.asset(
                                                getWeatherAnimation(
                                                  dayData['condition'],
                                                ),
                                                height: 30,
                                                width: 30,
                                              )
                                            : SizedBox(
                                                height: 30,
                                                width: 30,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                        Color
                                                      >(Colors.white),
                                                ),
                                              ),
                                        Text(
                                          dayData != null
                                              ? '${dayData['high']}°'
                                              : '--°',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Inter',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          dayData != null
                                              ? '${dayData['low']}°'
                                              : '--°',
                                          style: TextStyle(
                                            color: Color(0xFFBDBDBD),
                                            fontFamily: 'Inter',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
