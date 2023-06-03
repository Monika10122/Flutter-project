// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';

class WeatherForecastContainer extends StatefulWidget {
  final String location;
  final String temperature;
  final String weatherCondition;
  final List<Map<String, String>> weatherForecasts;

  const WeatherForecastContainer({
    Key? key,
    required this.location,
    required this.temperature,
    required this.weatherCondition,
    required this.weatherForecasts,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _WeatherForecastContainerState createState() =>
      _WeatherForecastContainerState();
}

class _WeatherForecastContainerState extends State<WeatherForecastContainer> {
  List<String> daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  Color getTemperatureColor(String temperature) {
    double temp = double.parse(temperature);
    if (temp > 30) {
      return Colors.red.withOpacity(0.7);
    } else if (temp >= 20 && temp <= 30) {
      return Colors.orange.withOpacity(0.7);
    } else if (temp >= 10 && temp < 20) {
      return Colors.yellow.withOpacity(0.7);
    } else if (temp >= 0 && temp < 10) {
      return Colors.white.withOpacity(0.7);
    } else {
      return Colors.blue.withOpacity(0.7);
    }
  }

  String getWeatherIconUrl(String weatherCondition) {
    switch (weatherCondition.toLowerCase()) {
      case 'cloudy':
        return 'https://openweathermap.org/img/w/04d.png';
      case 'sunny':
        return 'https://openweathermap.org/img/w/01d.png';
      case 'rainy':
        return 'https://openweathermap.org/img/w/10d.png';
      case 'snowy':
        return 'https://openweathermap.org/img/w/13d.png';
      case 'thunderstorm':
        return 'https://openweathermap.org/img/w/11d.png';
      case 'partly cloudy':
        return 'https://openweathermap.org/img/w/02d.png';
      case 'mist':
        return 'https://openweathermap.org/img/w/50d.png';
      case 'haze':
        return 'https://openweathermap.org/img/w/50d.png';
      case 'fog':
        return 'https://openweathermap.org/img/w/50d.png';
      case 'windy':
        return 'https://openweathermap.org/img/w/50d.png';
      default:
        return 'https://openweathermap.org/img/w/01d.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl = getWeatherIconUrl(widget.weatherCondition);

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFFBCEAD5).withOpacity(0.5),
              ),
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(imageUrl),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    widget.location,
                    style: const TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.temperature,
                    style: const TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.weatherCondition,
                    style: const TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFFBCEAD5).withOpacity(0.5),
              ),
              padding: const EdgeInsets.all(10.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        '5-Day Forecast',
                        style: TextStyle(
                          fontFamily: 'SpaceGrotesk',
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 300,
                      child: ListView.builder(
                        itemCount: widget.weatherForecasts.length,
                        itemBuilder: (context, index) {
                          String forecastDayOfWeek =
                              daysOfWeek[(DateTime.now().weekday + index) % 7];
                          String forecastTemperature = '';
                          String forecastWindSpeed = '';
                          String forecastPrecipitation = '';
                          String forecastWeatherCondition = '';
                          if (widget.weatherForecasts != null) {
                            forecastTemperature = widget.weatherForecasts[index]
                                    ['temperature'] ??
                                '';
                            forecastWindSpeed = widget.weatherForecasts[index]
                                    ['windSpeed'] ??
                                '';
                            forecastPrecipitation = widget
                                    .weatherForecasts[index]['precipitation'] ??
                                '';
                            forecastWeatherCondition =
                                widget.weatherForecasts[index]
                                        ['weatherCondition'] ??
                                    '';
                          }
                          Color temperatureColor =
                              getTemperatureColor(forecastTemperature);
                          String imageUrl = '';
                          switch (forecastWeatherCondition.toLowerCase()) {
                            case 'cloudy':
                              imageUrl =
                                  'https://openweathermap.org/img/w/04d.png';
                              break;
                            case 'sunny':
                              imageUrl =
                                  'https://openweathermap.org/img/w/01d.png';
                              break;
                            case 'rainy':
                              imageUrl =
                                  'https://openweathermap.org/img/w/10d.png';
                              break;
                            case 'snowy':
                              imageUrl =
                                  'https://openweathermap.org/img/w/13d.png';
                              break;
                            case 'thunderstorm':
                              imageUrl =
                                  'https://openweathermap.org/img/w/11d.png';
                              break;
                            case 'partly cloudy':
                              imageUrl =
                                  'https://openweathermap.org/img/w/02d.png';
                              break;
                            case 'mist':
                              imageUrl =
                                  'https://openweathermap.org/img/w/50d.png';
                              break;
                            case 'haze':
                              imageUrl =
                                  'https://openweathermap.org/img/w/50d.png';
                              break;
                            case 'fog':
                              imageUrl =
                                  'https://openweathermap.org/img/w/50d.png';
                              break;
                            case 'windy':
                              imageUrl =
                                  'https://openweathermap.org/img/w/50d.png';
                              break;
                            default:
                              imageUrl =
                                  'https://openweathermap.org/img/w/01d.png';
                          }

                          return SingleChildScrollView(
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4.0),
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: temperatureColor,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FadeInImage.assetNetwork(
                                    placeholder: 'lib/assets/sun.png',
                                    image: imageUrl,
                                    width: 50,
                                    height: 50,
                                    imageErrorBuilder:
                                        (context, error, stackTrace) {
                                      return const CircularProgressIndicator();
                                    },
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          forecastDayOfWeek,
                                          style: const TextStyle(
                                            fontFamily: 'SpaceGrotesk',
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Temperature: $forecastTemperature°C',
                                          style: const TextStyle(
                                            fontFamily: 'SpaceGrotesk',
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          'Wind Speed: $forecastWindSpeed km/h',
                                          style: const TextStyle(
                                            fontFamily: 'SpaceGrotesk',
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          'Precipitation: $forecastPrecipitation%',
                                          style: const TextStyle(
                                            fontFamily: 'SpaceGrotesk',
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
