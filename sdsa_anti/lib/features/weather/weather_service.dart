import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'weather_model.dart';

class WeatherService {
  Future<WeatherModel> fetchWeather() async {
    try {
      // 1. Handle permissions and availability
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return _errorState('Location permission denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return _errorState('Location perm. permanently denied');
      }

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return _errorState('Turn on Location/GPS to see weather');
      }

      // 2. Get current position with a fallback to last known
      Position? position;
      try {
        position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.low,
            timeLimit: Duration(seconds: 15),
          ),
        );
      } catch (e) {
        position = await Geolocator.getLastKnownPosition();
      }

      if (position == null) {
        return _errorState('Could not detect your spot');
      }

      // 3. Get area name
      String locationName = 'Current Location';
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          locationName =
              '${place.locality ?? place.subLocality ?? 'Unknown Area'}, ${place.administrativeArea ?? ''}';
        }
      } catch (e) {
        debugPrint('Geocoding error: $e');
      }

      // 4. Fetch from Open-Meteo
      final url =
          'https://api.open-meteo.com/v1/forecast?latitude=${position.latitude}&longitude=${position.longitude}&current_weather=true';
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['current_weather'] != null) {
          return WeatherModel.fromJson(data, locationName);
        } else {
          return _errorState('Weather data format error');
        }
      } else {
        return _errorState('Weather server busy (${response.statusCode})');
      }
    } catch (e) {
      debugPrint('Weather fetch error: $e');
      return _errorState('Check your internet connection');
    }
  }

  WeatherModel _errorState(String message) {
    return WeatherModel(
      temperature: 0.0,
      windspeed: 0.0,
      weatherCode: -1,
      locationName: message,
    );
  }
}
