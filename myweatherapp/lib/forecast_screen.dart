import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'weather_model.dart';

class ForecastScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('5-Day Forecast')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Consumer<WeatherModel>(
          builder: (context, model, child) {
            if (model.isLoading) {
              return CircularProgressIndicator();
            } else if (model.forecast == null) {
              return Text('No forecast data available');
            } else {
              return ListView.builder(
                itemCount: model.forecast?['list'].length,
                itemBuilder: (context, index) {
                  var forecastData = model.forecast?['list'][index];
                  return ListTile(
                    title: Text('Day ${index + 1}'),
                    subtitle: Text(
                      'Temp: ${forecastData['main']['temp']}°C, Weather: ${forecastData['weather'][0]['description']}'),
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