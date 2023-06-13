// ignore_for_file: prefer_const_declarations

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ignore: library_prefixes
import '../widgets/config.dart';
// ignore: library_prefixes
import '../widgets/search_bar.dart' as searchBar;
// ignore: library_prefixes
import '../widgets/widget.dart' as forecastContainer;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String location = '';
  String temperature = '';
  String weatherCondition = '';
  List<Map<String, String>> weatherForecasts = [];

  Future<void> fetchDataFromAPI(String city) async {
    
      // ignore: unused_local_variable
      final apiKey = Config.apiKey1;
    
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final cityName = data['name'] as String?;
        final temp = data['main']['temp'] as double?;
        final weatherDesc = data['weather'][0]['description'] as String?;

        if (cityName != null && temp != null && weatherDesc != null) {
          setState(() {
            location = cityName;
            temperature = '$temp°C';
            weatherCondition = weatherDesc;
          });
          fetchWeatherForecastsFromAPI(
              city); // Виклик функції для отримання прогнозу погоди
        } else {
          setState(() {
            location = 'Unknown';
            temperature = 'Unknown';
            weatherCondition = 'Unknown';
          });
        }
      } else {
        setState(() {
          location = 'Error';
          temperature = 'N/A';
          weatherCondition = 'N/A';
        });
      }
    } catch (e, stackTrace) {
      setState(() {
        location = 'Error';
        temperature = 'N/A';
        weatherCondition = 'N/A';
      });
      // ignore: avoid_print
      print('Error: $e');
      // ignore: avoid_print
      print('Stack trace: $stackTrace');
    }
  }

  Future<void> fetchWeatherForecastsFromAPI(String city) async {
    final apiKey = Config.apiKey1;
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        List<dynamic> forecasts = data['list'];
        for (int i = 1; i < 5; i++) {
          final forecastData = forecasts[i * 8];
          final temperature = forecastData['main']['temp'].toString();
          final weatherCondition = forecastData['weather'][0]['description']
              .toString()
              .toLowerCase();
          final windSpeed = forecastData['wind']['speed'] as double?;
          final precipitation = (forecastData['pop'] as num?)?.toInt();

          weatherForecasts.add({
            'temperature': temperature,
            'weatherCondition': weatherCondition,
            'windSpeed': windSpeed?.toString() ?? '0.0',
            'precipitation': precipitation?.toString() ?? '0',
          });
        }

        setState(() {
          // Оновлюємо UI з отриманими прогнозами погоди
        });
      } else {
        // ignore: avoid_print
        print('Failed to fetch weather forecasts');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error: $e');
    }
  }

  void _searchCity(String city) {
    weatherForecasts.clear();
    fetchDataFromAPI(city);
    setState(() {
      location = '';
      temperature = '';
      weatherCondition = '';
    });
  }

  @override
  void initState() {
    super.initState();
    weatherForecasts = []; // Ініціалізуємо список як пустий список
    fetchDataFromAPI('Kyiv'); // Виклик функції для отримання поточної погоди
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDEF5E5),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          children: [
            searchBar.SearchBar(
              onCitySelected: _searchCity,
            ),
            const SizedBox(height: 10.0),
            if (weatherForecasts.isNotEmpty)
              forecastContainer.WeatherForecastContainer(
                location: location,
                temperature: temperature,
                weatherCondition: weatherCondition,
                weatherForecasts: weatherForecasts,
              ),
          ],
        ),
      ),
    );
  }
}

class WeatherForecast {
  final String temperature;
  final String weatherCondition;
  final double windSpeed;
  final int precipitation;

  WeatherForecast({
    required this.temperature,
    required this.weatherCondition,
    required this.windSpeed,
    required this.precipitation,
  });
}
