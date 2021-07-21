import 'package:clima/screens/city_screen.dart';
import 'package:clima/services/weather.dart';
import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';

class LocationScreen extends StatefulWidget {
  final weatherData;

  const LocationScreen({Key? key, this.weatherData}) : super(key: key);

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late WeatherModel weather = WeatherModel();
  late int temperature;
  late String weatherIcon;
  late String weatherText;
  late String city;

  void updateUI({@required dynamic weatherData}) {
    setState(() {
      if (weatherData == null) {
        temperature = 0;
        weatherIcon = 'Error';
        weatherText = 'Cant\'t get current weather';
        city = '';
        return;
      }
      double temp = weatherData['main']['temp'];
      temperature = temp.toInt();
      var condition = weatherData['weather'][0]['id'];
      weatherIcon = weather.getWeatherIcon(condition);
      weatherText = weather.getMessage(temperature);
      city = weatherData['name'];
    });
  }

  @override
  void initState() {
    super.initState();
    updateUI(weatherData: widget.weatherData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    iconSize: 50.0,
                    onPressed: () async {
                      var weatherData = await weather.getLocationWeather();
                      updateUI(weatherData: weatherData);
                    },
                    icon: Icon(
                      Icons.near_me,
                    ),
                  ),
                  IconButton(
                    iconSize: 50.0,
                    onPressed: () async {
                      var typedCityName = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => CityScreen(),
                        ),
                      );
                      if (typedCityName != null) {
                        var weatherData =
                            await weather.getCityWeather(typedCityName);
                        updateUI(weatherData: weatherData);
                      }
                    },
                    icon: Icon(
                      Icons.location_city,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      temperature.toString() + '°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      weatherIcon,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  right: 15.0,
                  bottom: 15.0,
                ),
                child: Text(
                  "$weatherText in $city !",
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
