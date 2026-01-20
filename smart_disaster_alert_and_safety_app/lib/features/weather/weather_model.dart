class WeatherModel {
  final double temperature;
  final double windspeed;
  final int weatherCode;
  final String locationName;

  WeatherModel({
    required this.temperature,
    required this.windspeed,
    required this.weatherCode,
    required this.locationName,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json, String location) {
    final current = json['current_weather'];
    return WeatherModel(
      temperature: (current['temperature'] as num).toDouble(),
      windspeed: (current['windspeed'] as num).toDouble(),
      weatherCode: current['weathercode'],
      locationName: location,
    );
  }

  String get description {
    switch (weatherCode) {
      case 0:
        return 'Clear sky';
      case 1:
      case 2:
      case 3:
        return 'Mainly clear, partly cloudy, and overcast';
      case 45:
      case 48:
        return 'Fog and depositing rime fog';
      case 51:
      case 53:
      case 55:
        return 'Drizzle: Light, moderate, and dense intensity';
      case 61:
      case 63:
      case 65:
        return 'Rain: Slight, moderate and heavy intensity';
      case 71:
      case 73:
      case 75:
        return 'Snow fall: Slight, moderate, and heavy intensity';
      case 95:
        return 'Thunderstorm: Slight or moderate';
      default:
        return 'Unknown';
    }
  }
}
