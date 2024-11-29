import 'package:flutter/material.dart';
import 'weather_service.dart';

class WeatherModel extends ChangeNotifier {
  Map<String, dynamic>? currentWeather;
  Map<String, dynamic>? forecast;
  bool isLoading = false;

  List<String> checkedCities = []; // List of cities that were checked
  Map<String, double> cityTemperatures = {}; // Stores temperatures for cities

  final WeatherService _weatherService = WeatherService();

  // Fetches current weather for a city
  Future<void> fetchCurrentWeather(String city) async {
    isLoading = true;
    // Schedule the state update after the build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    try {
      currentWeather = await _weatherService.getCurrentWeather(city);

      // Save the temperature of the city
      if (currentWeather != null) {
        cityTemperatures[city] = currentWeather?['main']['temp'];
      }

      // Add city to checked cities list if not already present
      if (!checkedCities.contains(city)) {
        checkedCities.add(city);
      }
    } catch (e) {
      currentWeather = null;
    }
    isLoading = false;

    // Schedule the state update after the build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  // Fetches weather forecast for a city
  Future<void> fetchForecast(String city) async {
    isLoading = true;
    // Schedule the state update after the build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    try {
      forecast = await _weatherService.getForecast(city);
    } catch (e) {
      forecast = null;
    }
    isLoading = false;

    // Schedule the state update after the build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  // Retrieves the weather details for a city from the checked cities list
  Map<String, dynamic>? getWeatherDetailsForCity(String city) {
    if (currentWeather != null && checkedCities.contains(city)) {
      return currentWeather;
    }
    return null;
  }

  // Gets the temperature for a specific city
  double? getCityTemperature(String city) {
    return cityTemperatures[city];
  }

  // Clears all weather data (used for logout or resetting app state)
  void clearData() {
    currentWeather = null;
    forecast = null;
    isLoading = false;
    checkedCities.clear();
    cityTemperatures.clear();
    notifyListeners();
  }
}
