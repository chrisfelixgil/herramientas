class WeatherInfo {
  WeatherInfo({
    required this.time,
    required this.temperature,
    required this.apparentTemperature,
    required this.weatherCode,
    required this.isDay,
  });

  final String time;
  final double temperature;
  final double apparentTemperature;
  final int weatherCode;
  final bool isDay;

  factory WeatherInfo.fromJson(Map<String, dynamic> json) {
    final current = json['current'] as Map<String, dynamic>? ?? {};
    final isDayValue = current['is_day'];

    return WeatherInfo(
      time: current['time']?.toString() ?? '',
      temperature: (current['temperature_2m'] as num?)?.toDouble() ?? 0,
      apparentTemperature:
          (current['apparent_temperature'] as num?)?.toDouble() ?? 0,
      weatherCode: (current['weather_code'] as num?)?.toInt() ?? 0,
      isDay: isDayValue == 1 || isDayValue == true,
    );
  }

  String get description {
    if (weatherCode == 0) return 'Cielo despejado';
    if ([1, 2, 3].contains(weatherCode)) return 'Parcialmente nublado';
    if ([45, 48].contains(weatherCode)) return 'Neblina';
    if ([51, 53, 55, 56, 57].contains(weatherCode)) return 'Llovizna';
    if ([61, 63, 65, 66, 67].contains(weatherCode)) return 'Lluvia';
    if ([80, 81, 82].contains(weatherCode)) return 'Chubascos';
    if ([95, 96, 99].contains(weatherCode)) return 'Tormenta eléctrica';

    return 'Clima variable';
  }

  String get friendlyMessage {
    if (weatherCode == 0) {
      return 'Parece un buen día para salir, pero no olvides hidratarte.';
    }

    if ([1, 2, 3].contains(weatherCode)) {
      return 'El clima está tranquilo, con algunas nubes en el cielo.';
    }

    if ([61, 63, 65, 80, 81, 82].contains(weatherCode)) {
      return 'Lleva paraguas por si la lluvia aparece.';
    }

    if ([95, 96, 99].contains(weatherCode)) {
      return 'Ten cuidado: puede haber tormentas durante el día.';
    }

    return 'Revisa el clima antes de salir para estar preparado.';
  }
}
