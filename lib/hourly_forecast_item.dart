import 'package:flutter/material.dart';

class HourlyForecastItem extends StatelessWidget {
  final IconData icon;
  final String time;
  final String temperature;
  const HourlyForecastItem({
    super.key,
    required this.icon,
    required this.time,
    required this.temperature,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        width: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12)
        ),
        child: Column(
          children: [
            // Time
            Text(
              time,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8,),
            Icon(icon, size: 32,),
            const SizedBox(height: 8,),
            // value
            Text(temperature),
          ],
        ),
      ),
    );
  }
}
