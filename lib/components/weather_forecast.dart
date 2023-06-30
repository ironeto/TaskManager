import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/weather_forecast.dart';

class WeatherForecastComponent extends StatefulWidget {
  @override
  _WeatherForecastComponentState createState() =>
      _WeatherForecastComponentState();
}

class _WeatherForecastComponentState extends State<WeatherForecastComponent> {
  final String apiKey = '1919fcb13b6e4c96957161302233006'; // Replace with your API key

  Future<WeatherForecastModel> fetchWeatherForecast() async {
    final String apiUrl =
        'http://api.weatherapi.com/v1/current.json?key=$apiKey&q=London&aqi=no';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = WeatherForecastModel.fromJson(json.decode(response.body));
      return data;
    } else {
      throw Exception('Failed to fetch weather forecast');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WeatherForecastModel>(
      future: fetchWeatherForecast(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final weatherForecast = snapshot.data!;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Location: ${weatherForecast.location?.region ?? ""}'),
              Text(
                'Temperature: ${weatherForecast.current?.tempC?.toStringAsFixed(2) ?? ""}°C',
              ),
              Text('Weather Condition: ${weatherForecast.current?.condition?.text ?? ""}'),
              if (weatherForecast.current?.condition?.icon != null)
                Image.network(
                  'https:${weatherForecast.current!.condition!.icon}',
                  width: 64,
                  height: 64,
                ),
            ],
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        return CircularProgressIndicator();
      },
    );
  }
}
