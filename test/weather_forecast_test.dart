import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_manager/components/weather_forecast.dart';

// Mock HttpClient class
class MockHttpClient extends Mock implements http.Client {
  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    return http.Response(
      '{"status": "success", "data": {"location": {"region": "City"}, "current": {"temp_c": 25.0, "condition": {"text": "Sunny", "icon": "//example.com/icon.png"}}}}',
      200,
    );
  }
}

void main() {
  late TestGeolocatorPlatform testGeolocator; // Change the type to TestGeolocatorPlatform

  setUp(() {
    testGeolocator = TestGeolocatorPlatform();
    registerFallbackValue(LocationAccuracy.high);
  });

  testWidgets('Displays weather forecast when data is available', (WidgetTester tester) async {

    final position = await testGeolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    // Set up the component
    await tester.pumpWidget(
      MaterialApp(
        home: WeatherForecastComponent(position: position),
      ),
    );


    // Trigger the fetchWeatherForecast method
    await tester.pumpAndSettle();

    // Verify the expected UI elements
    expect(find.text('Location: City'), findsOneWidget);
    expect(find.text('Temperature: 25.00°C'), findsOneWidget);
    expect(find.text('Weather Condition: Sunny'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });
}


class TestGeolocatorPlatform extends Geolocator {
  @override
  Future<Position> getCurrentPosition({required LocationAccuracy desiredAccuracy, bool forceAndroidLocationManager = false}) async {
    return Position(
      latitude: 37.7749,
      longitude: -122.4194,
      timestamp: DateTime.now(),
      accuracy: 10.0,
      altitude: 100.0,
      heading: 90.0,
      speed: 50.0,
      speedAccuracy: 5.0,
    );
  }
}
