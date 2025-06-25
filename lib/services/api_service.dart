import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // ✅ Replace with your actual IP address that your Android device can access.
  static const baseUrl = 'http://192.168.154.89:5000';

  static Future<Map<String, dynamic>> fetchGoldData() async {
    final response = await http.get(Uri.parse('$baseUrl/gold-data'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load gold data');
    }
  }

  static Future<Map<String, dynamic>> predictPrice(String date) async {
    final response = await http.post(
      Uri.parse('$baseUrl/prediction'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'future_date': date},
      // ✅ Send as JSON
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to predict: ${response.statusCode}');
    }
  }

  static Future<List<dynamic>> fetchTrends(String timeframe) async {
    final response = await http.get(Uri.parse('$baseUrl/gold-data/$timeframe'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch trends');
    }
  }

  static Future<Map<String, dynamic>> fetchAnomalies() async {
    final response = await http.get(Uri.parse('$baseUrl/anomaly-detection'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch anomalies');
    }
  }

  static String getAnomalyPlotUrl() {
    return '$baseUrl/anomaly-plot';
  }
}
