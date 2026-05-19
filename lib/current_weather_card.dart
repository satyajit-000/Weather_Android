import 'package:flutter/material.dart';

import 'constants.dart';

class CurrentWeatherCard extends StatelessWidget {
  final double currentTemperature;
  final String currentWeather;

  const CurrentWeatherCard({super.key, required this.currentTemperature, required this.currentWeather});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text('$currentTemperature K',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16,),
          Icon(WEATHER_ICON_MAPPER[currentWeather] ?? Icons.sunny, size: 70,),
          const SizedBox(height: 16,),
          Text(
            currentWeather,
            style: const TextStyle(
                fontSize: 20
            ),
          ),

        ],
      ),
    );
  }
}
