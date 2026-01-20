import 'dart:async';
import 'package:flutter/material.dart';
import 'weather_service.dart';
import 'weather_model.dart';
import 'package:flutter_animate/flutter_animate.dart';

class WeatherCard extends StatefulWidget {
  const WeatherCard({super.key});

  @override
  State<WeatherCard> createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard> {
  final WeatherService _weatherService = WeatherService();
  WeatherModel? _weather;
  bool _isLoading = true;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
    // Refresh weather every 15 minutes for "realtime" accuracy
    _refreshTimer = Timer.periodic(const Duration(minutes: 15), (timer) {
      _fetchWeather();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchWeather() async {
    setState(() => _isLoading = true);
    try {
      final weather = await _weatherService.fetchWeather();
      if (mounted) {
        setState(() {
          _weather = weather;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  IconData _getWeatherIcon(int code) {
    if (code == 0) return Icons.wb_sunny;
    if (code < 40) return Icons.cloud;
    if (code < 70) return Icons.beach_access;
    if (code < 90) return Icons.ac_unit;
    return Icons.thunderstorm;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _weather == null) {
      return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [Colors.blue.shade100, Colors.blue.shade50],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(strokeWidth: 2),
              const SizedBox(height: 12),
              Text(
                'Pinpointing location...',
                style: TextStyle(color: Colors.blue.shade700, fontSize: 12),
              ),
            ],
          ),
        ),
      ).animate().shimmer(duration: 2.seconds);
    }

    if (_weather == null || _weather!.weatherCode == -1) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ListTile(
          leading: const Icon(Icons.location_off, color: Colors.red),
          title: Text(_weather?.locationName ?? 'Location error'),
          subtitle: const Text('Tap refresh to try again'),
          trailing: IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchWeather,
          ),
        ),
      );
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.blue.shade800, Colors.blue.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_weather!.temperature.round()}°C',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      _weather!.description,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _weather!.locationName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                Icon(
                      _getWeatherIcon(_weather!.weatherCode),
                      size: 64,
                      color: Colors.white,
                    )
                    .animate(onPlay: (controller) => controller.repeat())
                    .shimmer(duration: 2.seconds, color: Colors.white24)
                    .moveY(
                      begin: -5,
                      end: 5,
                      duration: 2.seconds,
                      curve: Curves.easeInOutSine,
                    ),
              ],
            ),
            Positioned(
              right: 0,
              top: 0,
              child: IconButton(
                icon: const Icon(
                  Icons.refresh,
                  size: 18,
                  color: Colors.white54,
                ),
                onPressed: _fetchWeather,
                tooltip: 'Refresh Weather',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
