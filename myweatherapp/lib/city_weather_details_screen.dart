import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'weather_model.dart';

class CitiesWeatherDetailsScreen extends StatefulWidget {
  @override
  _CitiesWeatherDetailsScreenState createState() =>
      _CitiesWeatherDetailsScreenState();
}

class _CitiesWeatherDetailsScreenState
    extends State<CitiesWeatherDetailsScreen> {
  bool _isDataFetched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final city = ModalRoute.of(context)!.settings.arguments as String;
    if (!_isDataFetched) {
      // Fetch weather data only if not already fetched
      Provider.of<WeatherModel>(context, listen: false)
          .fetchCurrentWeather(city)
          .then((_) {
        setState(() {
          _isDataFetched = true; // Mark data as fetched
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final city = ModalRoute.of(context)!.settings.arguments as String;
    final model = Provider.of<WeatherModel>(context);

    // Get current time adjusted for the city's timezone
    final int cityTimeZoneOffset = model.currentWeather?['timezone'] ?? 0; // Offset in seconds
    final DateTime now = DateTime.now().toUtc().add(Duration(seconds: cityTimeZoneOffset));
    final String formattedTime = DateFormat('hh:mm a').format(now);

    return Scaffold(
      appBar: AppBar(
        title: Text('$city Weather', style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _isDataFetched
            ? model.currentWeather == null
                ? const Center(
                    child: Text(
                      'No weather data available for this city',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView(
                      children: [
                        // Time and city name at the top
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '$city',
                              style: const TextStyle(
                                  fontSize: 36,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '$formattedTime',
                              style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Weather icon and temperature
                        Row(
                          children: [
                            Icon(
                              Icons.wb_sunny,
                              color: Colors.yellow,
                              size: 40,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '${model.currentWeather?['main']['temp']?.toStringAsFixed(1) ?? 'N/A'}°C',
                              style: const TextStyle(
                                fontSize: 50,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Cards for weather details
                        _buildWeatherCard(
                          'Humidity: ${model.currentWeather?['main']['humidity']?.toString() ?? 'N/A'}%',
                          Icons.cloud,
                          Colors.blueAccent,
                        ),
                        _buildWeatherCard(
                          'Weather: ${model.currentWeather?['weather'][0]['description'] ?? 'N/A'}',
                          Icons.wb_sunny,
                          Colors.orange,
                        ),
                        _buildWeatherCard(
                          'Wind Speed: ${model.currentWeather?['wind']['speed']?.toString() ?? 'N/A'} m/s',
                          Icons.air,
                          Colors.green,
                        ),
                        _buildWeatherCard(
                          'Pressure: ${model.currentWeather?['main']['pressure']?.toString() ?? 'N/A'} hPa',
                          Icons.speed,
                          Colors.purple,
                        ),
                        _buildWeatherCard(
                          'Cloudiness: ${model.currentWeather?['clouds']['all']?.toString() ?? 'N/A'}%',
                          Icons.cloud_circle,
                          Colors.grey,
                        ),
                        _buildWeatherCard(
                          'Feels Like: ${model.currentWeather?['main']['feels_like']?.toStringAsFixed(1) ?? 'N/A'}°C',
                          Icons.thermostat,
                          Colors.red,
                        ),
                        const SizedBox(height: 20),

                        // Refresh button
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isDataFetched = false;
                              });
                              Provider.of<WeatherModel>(context, listen: false)
                                  .fetchCurrentWeather(city)
                                  .then((_) {
                                setState(() {
                                  _isDataFetched = true;
                                });
                              });
                            },
                            child: const Text('Refresh Weather Data'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blueAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
            : const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
      ),
    );
  }

  // A reusable widget for weather details inside cards
  Widget _buildWeatherCard(String text, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: color.withOpacity(0.2),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}