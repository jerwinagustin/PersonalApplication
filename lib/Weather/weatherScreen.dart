import 'package:flutter/material.dart';
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

  _fetchWeather() async {
    String locationName = await _weatherService.getCurrentLocation();

    try {
      final weather = await _weatherService.getWeather(locationName);

      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();

    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFF06011D),
      body: SingleChildScrollView(
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text(
                                    _weather?.locationName ??
                                        "loading location...",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Inter',
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),

                                Text(
                                  _weather != null
                                      ? '${_weather!.temperature.round()}°C'
                                      : "Loading...",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
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
