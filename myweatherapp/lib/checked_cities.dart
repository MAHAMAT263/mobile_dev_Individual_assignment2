import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'weather_model.dart';

class CheckedCitiesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checked Cities', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlueAccent, Colors.blueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Consumer<WeatherModel>(
          builder: (context, model, child) {
            if (model.checkedCities.isEmpty) {
              return const Center(
                child: Text(
                  'No cities checked yet!',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: model.checkedCities.length,
                itemBuilder: (context, index) {
                  String city = model.checkedCities[index];
                  double? temp = model.cityTemperatures[city];
                  return ListTile(
                    leading: const Icon(Icons.location_city, color: Colors.white),
                    title: Text(
                      city,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    trailing: Text(
                      '${temp?.toStringAsFixed(1)}°C',
                      style: const TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                    onTap: () {
                      // Navigate to CitiesWeatherDetailsScreen, passing the city name
                      Navigator.pushNamed(context, '/citiesWeatherDetails', arguments: city);
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}