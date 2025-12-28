import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService(this.apiKey);

Future<WeatherModel> getWeatherByLocation(
  double lat,
  double lon,
) async {
  final response = await http.get(
    Uri.parse(
      '$BASE_URL?lat=$lat&lon=$lon&appid=$apiKey&units=metric',
    ),
  );

  if (response.statusCode == 200) {
    return WeatherModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load weather data');
  }
}


  // get permision
  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    // fetch the current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    // convert the location into a list placemark object
    List<Placemark> placemarks =
     await placemarkFromCoordinates(position.latitude, position.longitude);
    // extract the city name from the first place
    String? city = placemarks[0].locality;

    return city ?? "";
  }
}
