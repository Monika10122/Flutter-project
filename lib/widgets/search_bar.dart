// ignore_for_file: library_private_types_in_public_api, prefer_const_declarations

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

import 'config.dart';

class SearchBar extends StatefulWidget {
  final void Function(String) onCitySelected;

  const SearchBar({required this.onCitySelected});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _searchController = TextEditingController();
  bool _isConnected = true;
  List<String> _places = [];

  Future<void> _getData(String query) async {
    if (!_isConnected) {
      setState(() {
        _places = ['No internet connection'];
      });
      return;
    }


    final apiKey = Config.apiKey2;
    final url =
        'https://api.mapbox.com/geocoding/v5/mapbox.places/$query.json?access_token=$apiKey&types=place';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final features = data['features'];
      final List<String> places = [];
      for (var feature in features) {
        final placeName = feature['place_name'];
        places.add(placeName);
        if (places.length >= 3) {
          break;
        }
      }

      setState(() {
        _places = places;
      });
    } else {
      setState(() {
        _places = ['Request failed with status: ${response.statusCode}'];
      });
    }
  }

  Future<void> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          _isConnected = true;
        });
      }
    } on SocketException catch (e, stackTrace) {
      setState(() {
        _isConnected = false;
      });
      print('Error: $e');
      print('Stack trace: $stackTrace');
    }
  }

  void _searchCity(String city) {
    widget.onCitySelected(city);
    _clearScreen();
  }

  void _clearScreen() {
    setState(() {
      _searchController.clear();
      _places = [];
    });
    FocusScope.of(context).unfocus();
  }

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: <Widget>[
          TextField(
            style: const TextStyle(fontFamily: "SpaceGrotesk"),
            controller: _searchController,
            decoration: InputDecoration(
              fillColor: Colors.black87.withOpacity(0.1),
              filled: true,
              hintText: 'Search Location',
              suffixIcon: IconButton(
                color: const Color(0xFF6096B4),
                icon: const Icon(Icons.clear),
                onPressed: _clearScreen,
              ),
              prefixIcon: IconButton(
                color: const Color(0xFF6096B4),
                icon: const Icon(Icons.search),
                onPressed: () {
                  final city = _searchController.text;
                  _searchCity(city);
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            onChanged: (value) {
              if (value.length > 1) {
                Future.delayed(const Duration(milliseconds: 150), () {
                  _getData(value);
                });
              } else {
                setState(() {
                  _places = [];
                });
              }
            },
            onSubmitted: _searchCity,
            onTap: _clearScreen,
          ),
          if (_places.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.withOpacity(0.5),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: _places.length,
                separatorBuilder: (context, index) => Divider(
                  color: Colors.grey.withOpacity(0.7),
                  height: 1.0,
                ),
                itemBuilder: (context, index) {
                  final place = _places[index];
                  return ListTile(
                    title: Text(place),
                    onTap: () {
                      _searchCity(place);
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
