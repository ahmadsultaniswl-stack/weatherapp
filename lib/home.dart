import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'api_services.dart';
import 'detail.dart';
import 'weather_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  WeatherModel? weather;
  bool isLoading = true;
  Timer? refreshTimer;
  String? errorMessage;

  TextEditingController cityController = TextEditingController();

  final double defaultLat = 30.6944;
  final double defaultLon = 73.6719;

  @override
  void initState() {
    super.initState();
    _handleLocationAndFetchWeather();
    _startAutoRefresh();
  }

  @override
  void dispose() {
    refreshTimer?.cancel();
    cityController.dispose();
    super.dispose();
  }

  void _startAutoRefresh() {
    refreshTimer = Timer.periodic(Duration(minutes: 10), (_) {
      _handleLocationAndFetchWeather();
    });
  }

  Future<void> _handleLocationAndFetchWeather() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    double lat = defaultLat;
    double lon = defaultLon;

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (serviceEnabled &&
          permission != LocationPermission.denied &&
          permission != LocationPermission.deniedForever) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        lat = position.latitude;
        lon = position.longitude;
      } else {
        errorMessage = "Using default location (Sahiwal)";
      }

      WeatherModel? result = await WeatherApi.fetchWeatherByLatLon(lat, lon);

      if (result == null) {
        throw Exception('Failed to fetch weather data');
      }

      setState(() {
        weather = result;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching location/weather: $e");
      WeatherModel? result = await WeatherApi.fetchWeatherByLatLon(
        defaultLat,
        defaultLon,
      );
      setState(() {
        weather = result;
        isLoading = false;
        errorMessage = result != null
            ? "Showing weather for Sahiwal"
            : "Unable to fetch weather data";
      });
    }
  }

  Future<void> fetchWeatherByCity() async {
    String city = cityController.text.trim();
    if (city.isEmpty) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    WeatherModel? result = await WeatherApi.fetchWeather(city);

    setState(() {
      if (result != null) {
        weather = result;
        errorMessage = null;
      } else {
        errorMessage = "City not found. Please try again.";
      }
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A237E), Color(0xFF0D47A1), Color(0xFF1976D2)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _buildSearchBar(),
                        SizedBox(height: 30),
                        if (isLoading)
                          _buildLoadingState()
                        else if (weather != null)
                          _buildWeatherContent()
                        else
                          _buildErrorState(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.cloud_queue, color: Colors.white, size: 28),
          ),
          SizedBox(width: 12),
          Text(
            "WeatherCast",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          Spacer(),
          if (weather != null && !isLoading)
            IconButton(
              icon: Icon(Icons.refresh, color: Colors.white),
              onPressed: _handleLocationAndFetchWeather,
            ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: TextField(
        controller: cityController,
        style: TextStyle(color: Colors.white, fontSize: 16),
        cursorColor: Colors.white,
        decoration: InputDecoration(
          hintText: "Search city...",
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
          prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.7)),
          suffixIcon: IconButton(
            icon: Icon(Icons.arrow_forward, color: Colors.white),
            onPressed: fetchWeatherByCity,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
        onSubmitted: (_) => fetchWeatherByCity(),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      children: [
        SizedBox(height: 80),
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 3,
          ),
        ),
        SizedBox(height: 20),
        Text(
          "Fetching weather data...",
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Column(
      children: [
        SizedBox(height: 60),
        Icon(Icons.cloud_off, color: Colors.white.withOpacity(0.6), size: 80),
        SizedBox(height: 20),
        Text(
          errorMessage ?? "Unable to load weather data",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _handleLocationAndFetchWeather,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Color(0xFF1976D2),
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: Text("Retry", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildWeatherContent() {
    return Column(
      children: [
        _buildMainWeatherCard(),
        SizedBox(height: 30),
        _buildWeatherStats(),
        SizedBox(height: 30),
        _buildActionButtons(),
        if (errorMessage != null) ...[
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              errorMessage!,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildMainWeatherCard() {
    return Container(
      padding: EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            weather!.name ?? "Unknown",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
          Text(
            "${weather!.sys?.country ?? "PK"}",
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${weather!.main?.temp?.toStringAsFixed(1) ?? "--"}",
                style: TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                "°C",
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.white.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.water_drop,
                color: Colors.white.withOpacity(0.8),
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                "${weather!.main?.humidity ?? 0}%",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 16,
                ),
              ),
              SizedBox(width: 20),
              Icon(Icons.air, color: Colors.white.withOpacity(0.8), size: 20),
              SizedBox(width: 8),
              Text(
                "${(weather!.wind?.speed ?? 0).toStringAsFixed(1)} km/h",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _capitalize(weather!.weather?[0].description ?? "--"),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.thermostat,
            label: "Feels Like",
            value: "${weather!.main?.feelsLike?.toStringAsFixed(1) ?? "--"}°C",
          ),
        ),
        SizedBox(width: 15),
        Expanded(
          child: _buildStatCard(
            icon: Icons.compress,
            label: "Pressure",
            value: "${weather!.main?.pressure ?? 0} hPa",
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.8), size: 28),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DetailScreen(data: weather!)),
              );
            },
            icon: Icon(Icons.info_outline, color: Color(0xFF1976D2)),
            label: Text("View Details"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Color(0xFF1976D2),
              padding: EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ),
        SizedBox(width: 15),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _handleLocationAndFetchWeather,
            icon: Icon(Icons.my_location, color: Colors.white),
            label: Text("My Location"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF0D47A1),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
