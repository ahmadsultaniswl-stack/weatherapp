import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'weather_model.dart';

class WeatherApi {

  static const String apiKey = "979305c7bad55b92de9875e9ee8f88f1";

  // Fetch weather by city (Pakistan only)
  static Future<WeatherModel?> fetchWeather(String city) async {
    try {
      if (city.isEmpty) return null;

      // Encode city name and append country code PK
      final encodedCity = Uri.encodeComponent(city);

      final url = "https://api.openweathermap.org/data/2.5/weather?q=$encodedCity,PK&appid=$apiKey&units=metric";

      final response = await http.get(Uri.parse(url));

      print("City Weather URL: $url");
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(jsonDecode(response.body));
      } else {
        print("city not found or API error");
        return null;
      }
    } catch (e) {
      print("error fetching city weather: $e");
      return null;
    }
  }

  // Fetch weather by latitude & longitude
  static Future<WeatherModel?> fetchWeatherByLatLon(double lat, double lon) async {
    try {
      final url = "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric";

      final response = await http.get(Uri.parse(url));

      print("LatLon Weather URL: $url");
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(jsonDecode(response.body));
      } else {
        print("Location weather not found");
        return null;
      }
    } catch (e) {
      print("Error fetching location weather: $e");
      return null;
    }
  }




  //post Api Function for post login in class
  Future postApi( BuildContext context,String email, String password)async{
    final response = await http.post(Uri.parse("https://reqres.in/api/register"),
      headers: {
        "Content-Type" : "application/json",
        "x-api-key" : "reqres_9b030a29766241b9b6cba48a82d6bdd3"
      },
      body: jsonEncode({
        "email" : email,
        "password" : password,
      }),
    );

    if(response.statusCode == 200){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login Successfully")));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login Failed!!")));
    }
  }


}



// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'weather_model.dart';
//
// class WeatherApi {
//   static Future<WeatherModel?> fetchWeather(String city) async {
//     try {
//       final url = "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=979305c7bad55b92de9875e9ee8f88f1&units=metric";
//       final response = await http.get(Uri.parse(url));
//
//       print(response.statusCode);
//       print(response.body);
//
//       if (response.statusCode == 200) {
//         return WeatherModel.fromJson(jsonDecode(response.body));
//       } else {
//         print("City not found or API error");
//         return null;
//       }
//     } catch (e) {
//       print("Error: $e");
//       return null;
//     }
//   }
//
//
//   // Naya method: Fetch by latitude & longitude
//   // WeatherApi.dart
//   static Future<WeatherModel?> fetchWeatherByLatLon(double lat,
//       double lon) async {
//     try {
//       final url = "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=979305c7bad55b92de9875e9ee8f88f1&units=metric"; // ✅ API key fix
//       final response = await http.get(Uri.parse(url));
//
//       print(response.statusCode);
//       print(response.body);
//
//       if (response.statusCode == 200) {
//         return WeatherModel.fromJson(jsonDecode(response.body));
//       } else {
//         print("Location weather not found");
//         return null;
//       }
//     } catch (e) {
//       print("Error: $e");
//       return null;
//     }
//   }
// }


























// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'weather_model.dart';
//
// class WeatherApi {
//   static Future<WeatherModel?> fetchWeather(String city) async {
//     try {
//       final response = await http.get(
//         Uri.parse(
//             "https://api.openweathermap.org/data/2.5/weather?q=$city,PK&appid=979305c7bad55b92de9875e9ee8f88f1&units=metric"),
//       );
//
//       if (response.statusCode == 200) {
//         return WeatherModel.fromJson(jsonDecode(response.body));
//       } else {
//         print("City not found");
//         return null;
//       }
//     } catch (e) {
//       print("Error: $e");
//       return null;
//     }
//   }
// }



















// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:weatherapp/weather_model.dart';
//
// class WeatherApi {
//
//   static Future<WeatherModel?> fetchWeather(String city) async {
//     try {
//       final response = await http.get(
//         Uri.parse(
//           "https://api.openweathermap.org/data/2.5/weather?q=$city,PK&appid=979305c7bad55b92de9875e9ee8f88f1&units=metric",
//         ),
//       );
//
//       if (response.statusCode == 200) {
//         return WeatherModel.fromJson(jsonDecode(response.body));
//       } else {
//         print("City not found");
//         return null;
//       }
//
//     } catch (e) {
//       print("Error: $e");
//       return null;
//     }
//   }
// }
