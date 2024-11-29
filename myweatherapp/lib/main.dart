import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';
import 'forecast_screen.dart';
import 'weather_model.dart';
import 'checked_cities.dart';
import 'city_weather_details_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WeatherModel(),
      child: MaterialApp(
        title: 'Weather App',
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          '/forecast': (context) => ForecastScreen(),
          '/checkedCities': (context) => CheckedCitiesScreen(),
          '/citiesWeatherDetails': (context) => CitiesWeatherDetailsScreen(),
        },
      ),
    );
  }
}
