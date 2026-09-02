import 'package:flutter/material.dart';

import 'weather_model.dart';

class DetailScreen extends StatelessWidget {
  final WeatherModel data;

  DetailScreen({required this.data});

  String formatTimestamp(int? timestamp) {
    if (timestamp == null) return "-";
    return DateTime.fromMillisecondsSinceEpoch(
      timestamp * 1000,
    ).toLocal().toString().substring(0, 16);
  }

  String formatTime(int? timestamp) {
    if (timestamp == null) return "-";
    return DateTime.fromMillisecondsSinceEpoch(
      timestamp * 1000,
    ).toLocal().toString().substring(11, 16);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0D47A1),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF000080),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Weather Details",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A237E), Color(0xFF000080)],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A237E), Color(0xFF0D47A1), Color(0xFF1976D2)],
          ),
        ),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderCard(),
              SizedBox(height: 20),
              _buildSectionTitle("🌤️ Weather Condition", Icons.cloud_queue),
              SizedBox(height: 12),
              _buildWeatherInfoCard(),
              SizedBox(height: 20),
              _buildSectionTitle("🌡️ Temperature Details", Icons.thermostat),
              SizedBox(height: 12),
              _buildTemperatureGrid(),
              SizedBox(height: 20),
              _buildSectionTitle("💨 Wind & Air", Icons.air),
              SizedBox(height: 12),
              _buildWindCard(),
              SizedBox(height: 20),
              _buildSectionTitle("📍 Location & System", Icons.location_on),
              SizedBox(height: 12),
              _buildLocationCard(),
              SizedBox(height: 20),
              _buildAdditionalInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: EdgeInsets.all(24),
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
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(_getWeatherIcon(), size: 48, color: Colors.white),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.name ?? "Unknown",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "${data.sys?.country ?? "PK"}",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                SizedBox(height: 8),
                // Fixed: Wrapped in Flexible to prevent overflow
                Wrap(
                  spacing: 12,
                  runSpacing: 4,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.white.withOpacity(0.7),
                        ),
                        SizedBox(width: 4),
                        Text(
                          "Lat: ${data.coord?.lat?.toStringAsFixed(2) ?? "--"}°",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.white.withOpacity(0.7),
                        ),
                        SizedBox(width: 4),
                        Text(
                          "Lon: ${data.coord?.lon?.toStringAsFixed(2) ?? "--"}°",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.9), size: 24),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherInfoCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Icon(
                  Icons.cloud,
                  color: Colors.white.withOpacity(0.8),
                  size: 32,
                ),
                SizedBox(height: 8),
                Text(
                  data.weather?[0].main ?? "--",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  _capitalize(data.weather?[0].description ?? "--"),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Container(height: 50, width: 1, color: Colors.white.withOpacity(0.2)),
          Expanded(
            child: Column(
              children: [
                Icon(
                  Icons.cloud_queue,
                  color: Colors.white.withOpacity(0.8),
                  size: 32,
                ),
                SizedBox(height: 8),
                Text(
                  "Cloud Cover",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
                Text(
                  "${data.clouds?.all ?? 0}%",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(height: 50, width: 1, color: Colors.white.withOpacity(0.2)),
          Expanded(
            child: Column(
              children: [
                Icon(
                  Icons.remove_red_eye,
                  color: Colors.white.withOpacity(0.8),
                  size: 32,
                ),
                SizedBox(height: 8),
                Text(
                  "Visibility",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
                Text(
                  "${(data.visibility ?? 0) ~/ 1000} km",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemperatureGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.2,
      children: [
        _buildTempCard(
          "Temperature",
          "${data.main?.temp?.toStringAsFixed(1) ?? "--"}°C",
          Icons.thermostat,
          Colors.orange,
        ),
        _buildTempCard(
          "Feels Like",
          "${data.main?.feelsLike?.toStringAsFixed(1) ?? "--"}°C",
          Icons.device_thermostat,
          Colors.red,
        ),
        _buildTempCard(
          "Min Temp",
          "${data.main?.tempMin?.toStringAsFixed(1) ?? "--"}°C",
          Icons.thermostat_outlined,
          Colors.lightBlue,
        ),
        _buildTempCard(
          "Max Temp",
          "${data.main?.tempMax?.toStringAsFixed(1) ?? "--"}°C",
          Icons.thermostat_auto,
          Colors.deepOrange,
        ),
        _buildTempCard(
          "Pressure",
          "${data.main?.pressure ?? 0} hPa",
          Icons.speed,
          Colors.purple,
        ),
        _buildTempCard(
          "Humidity",
          "${data.main?.humidity ?? 0}%",
          Icons.water_drop,
          Colors.cyan,
        ),
      ],
    );
  }

  Widget _buildTempCard(
    String title,
    String value,
    IconData icon,
    Color iconColor,
  ) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor.withOpacity(0.8), size: 32),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWindCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Icon(Icons.air, color: Colors.white.withOpacity(0.8), size: 32),
                SizedBox(height: 8),
                Text(
                  "${data.wind?.speed?.toStringAsFixed(1) ?? "--"}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "km/h",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Speed",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(height: 60, width: 1, color: Colors.white.withOpacity(0.2)),
          Expanded(
            child: Column(
              children: [
                Icon(
                  Icons.explore,
                  color: Colors.white.withOpacity(0.8),
                  size: 32,
                ),
                SizedBox(height: 8),
                Text(
                  "${data.wind?.deg ?? 0}°",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Direction",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (data.wind?.gust != null) ...[
            Container(
              height: 60,
              width: 1,
              color: Colors.white.withOpacity(0.2),
            ),
            Expanded(
              child: Column(
                children: [
                  Icon(
                    Icons.bolt,
                    color: Colors.white.withOpacity(0.8),
                    size: 32,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "${data.wind?.gust?.toStringAsFixed(1) ?? "--"}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "km/h",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Gust",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLocationCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Icon(
                      Icons.flag,
                      color: Colors.white.withOpacity(0.8),
                      size: 28,
                    ),
                    SizedBox(height: 8),
                    Text(
                      data.sys?.country ?? "--",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Country",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Icon(
                      Icons.wb_sunny,
                      color: Colors.orange.withOpacity(0.8),
                      size: 28,
                    ),
                    SizedBox(height: 8),
                    Text(
                      formatTime(data.sys?.sunrise),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Sunrise",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Icon(
                      Icons.nights_stay,
                      color: Colors.indigo.withOpacity(0.8),
                      size: 28,
                    ),
                    SizedBox(height: 8),
                    Text(
                      formatTime(data.sys?.sunset),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Sunset",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Divider(color: Colors.white.withOpacity(0.2)),
          SizedBox(height: 16),
          // Fixed: Using Wrap instead of Row to prevent overflow
          Wrap(
            spacing: 16,
            runSpacing: 12,
            alignment: WrapAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.timer,
                    color: Colors.white.withOpacity(0.7),
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "UTC${(data.timezone ?? 0) ~/ 3600}",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.white.withOpacity(0.7),
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "ID: ${data.id ?? "--"}",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfo() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 8,
        alignment: WrapAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.verified,
                color: Colors.white.withOpacity(0.7),
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                "Code: ${data.cod ?? "--"}",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.update,
                color: Colors.white.withOpacity(0.7),
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                "Updated: ${formatTimestamp(data.dt)}",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getWeatherIcon() {
    String? weatherMain = data.weather?[0].main;
    switch (weatherMain?.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;
      case 'clouds':
        return Icons.cloud;
      case 'rain':
        return Icons.grain;
      case 'snow':
        return Icons.ac_unit;
      case 'thunderstorm':
        return Icons.flash_on;
      case 'drizzle':
        return Icons.beach_access;
      default:
        return Icons.cloud_queue;
    }
  }

  String _capitalize(String? text) {
    if (text == null || text.isEmpty) return "--";
    return text[0].toUpperCase() + text.substring(1);
  }
}
