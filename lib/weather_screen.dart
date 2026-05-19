import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additional_information.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secrets.dart';
import 'constants.dart';
import 'current_weather_card.dart';
import 'hourly_forecast_item.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = 'Hyderabad';
      final res = await http.get(
          Uri.parse(
              'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$OPEN_WEATHER_API_KEY'
          )
      );
      final data = jsonDecode(res.body);

      if (data['cod'] != '200') {
        throw 'An unexpected error occurred "${data['message']}"';
      }
      return data;
    } catch (e) {
      throw e.toString();
    }

  }


  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  void refresh() {
    setState(() {
      weather = getCurrentWeather();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),
        ),
        elevation: 32,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: refresh,
            icon:  const Icon(Icons.refresh),
          ),
        ],
      ),
      body:
      FutureBuilder(
        future: weather,
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (asyncSnapshot.hasError) {
            return Center(child: Text(asyncSnapshot.error.toString()));
          }

          final data = asyncSnapshot.data!;

          final List<dynamic> hourlyForecastList = data['list'];
          final currentWeatherData = hourlyForecastList[0];
          final currentTemperature = currentWeatherData['main']['temp'];
          final currentWeather = currentWeatherData['weather'][0]['main'];
          final currentHumidity = currentWeatherData['main']['humidity'];
          final currentPressure = currentWeatherData['main']['pressure'];
          final currentWindSpeed = currentWeatherData['wind']['speed'];

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Main card
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: CurrentWeatherCard(
                          currentTemperature: currentTemperature,
                          currentWeather: currentWeather,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20,),

                // Hourly Forecast
                Row(
                  children: [
                    const Text(
                      'Hourly Forecast',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24
                      ),
                    ),
                    Card(child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
                      child: Text('$HOURLY_FORCAST_COUNT'),
                    ))

                  ],
                ),
                const SizedBox(height: 8,),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    itemCount: HOURLY_FORCAST_COUNT,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final foreCast = hourlyForecastList[index + 1];
                      final dtTime = DateTime.parse(foreCast['dt_txt']);
                      final time = DateFormat.jm().format(dtTime);
                      final temp = foreCast['main']['temp'];
                      final weather = foreCast['weather'][0]['main'];

                      return HourlyForecastItem(
                              icon: WEATHER_ICON_MAPPER[weather] ?? Icons.sunny,
                              time: time,
                              temperature: '$temp K',
                            );


                    }),
                ),
                const SizedBox(height: 20,),

                // Additional Information
                const Text(
                  'Additional Information',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24
                  ),
                ),
                const SizedBox(height: 8,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInformation(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      value: '$currentHumidity',
                    ),
                    AdditionalInformation(
                      icon: Icons.air,
                      label: 'Wind Speed',
                      value: '$currentWindSpeed',
                    ),
                    AdditionalInformation(
                      icon: Icons.beach_access,
                      label: 'Pressure',
                      value: '$currentPressure',
                    ),
                  ],
                ),
              ],
            ),
            );
        }
      ),

    );
  }
}
