import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey =
      'c32c088d00d4ff723ef5914ef2f713e4'; // OpenWeatherMap API key

  // Fetch current weather data
  Future<Map<String, dynamic>> getCurrentWeather(String city) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  // Fetch weather forecast
  Future<Map<String, dynamic>> getForecast(String city) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load forecast data');
    }
  }

  // Fetch historical weather data (using a specific date)
  Future<Map<String, dynamic>> getHistoricalWeather(
      double lat, double lon, int timestamp) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/onecall/timemachine?lat=$lat&lon=$lon&dt=$timestamp&appid=$apiKey'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load historical data');
    }
  }
}
