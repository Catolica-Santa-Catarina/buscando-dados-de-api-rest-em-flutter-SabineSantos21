import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../services/networking.dart';
import '../services/weather.dart';
import 'location_screen.dart';
import 'dart:convert';

const apiKey = '7191fc16a527941ec7e65989f28901e2';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  late final dynamic localWeatherData;
  late double latitude;
  late double longitude;

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  Widget build(BuildContext context) {
    return const Center(
      child: SpinKitDoubleBounce(
        color: Colors.white,
        size: 100.0,
      ),
    );
  }

  Future<void> getLocation() async {
    var location = Location();
    await location.getCurrentLocation();

    latitude = location.latitude;
    longitude = location.longitude;
    getData();
  }

  void getData() async {
    NetworkHelper networkHelper = NetworkHelper('https://api.openweathermap.org/'
        'data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric');
    var weatherData = await networkHelper.getData();
    pushToLocationScreen(weatherData);
  }

  /*void getData(double latitude, double longitude) async {
    var url = Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric');
    http.Response response = await http.get(url);

    if (response.statusCode == 200) { // se a requisição foi feita com sucesso
      var data = response.body;
      var jsonData = jsonDecode(data);

      var cityName = jsonData['name'];
      var temperature = jsonData['main']['temp'];
      var weatherCondition = jsonData['weather'][0]['id'];
      print('cidade: $cityName, temperatura: $temperature, condição: $weatherCondition');
      print(data);  // imprima o resultado
    } else {
      print(response.statusCode);  // senão, imprima o código de erro
    }
  }*/

  void pushToLocationScreen(dynamic weatherData) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return LocationScreen(locationWeatherData: weatherData);
    }));
  }
}
